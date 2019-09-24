window.onload = () => {
    // Make sure to disable double tap zoom.
    var meta = document.createElement('meta');
    meta.name = 'viewport';
    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, shrink-to-fit=no';

    var style = document.createElement('style');
    style.type = 'text/css';
    style.innerText = '* { -webkit-user-select: none; -webkit-touch-callout: none; }';

    var oledBurnInProtectionCss = document.createElement('style');
    oledBurnInProtectionCss.id = 'oledBurnInProtectionCss';
    oledBurnInProtectionCss.type = 'text/css';
    oledBurnInProtectionCss.innerText = '.anti-burnin { animation: antiBurninV 60s linear infinite; padding-top: 0; }';
    oledBurnInProtectionCss.innerText += '@keyframes antiBurninV { 0%, 100% { padding-top: -10px; } 50% { padding-top: 10px; } }';

    var head = document.getElementsByTagName('head')[0];
    head.appendChild(meta);
    head.appendChild(style);
    head.appendChild(oledBurnInProtectionCss);

    window.exo.init();
}

window.exo = (() => {
    let formatRe = /{([\w\.]+:?([\w\,]+)?)}/g; // second part of the regexp is meant to match an optional modifier or multiple modifiers
    let currentData = {};
    let boundFunctions = {};
    let eventHandlers = {};
    let filters = {};
    let actions = {};
    let modifiers = {};
    let options = {
        'autobind': true
    };

    function applyMods(val, mods) {
        if(!Array.isArray(mods) || mods.length === 0) return val; // no modifiers, return original value

        let _val = val; // clone
        for(let modName of mods) {
            if(modifiers[modName]) { //  skip if modifier not found
                _val = modifiers[modName](_val);
            }
        }
        return _val;
    }

    function getValue(name, mods) {
        let val = currentData[name];
        val = applyMods(val, mods);

        if (filters[name]) {
            return filters[name](val);
        } else {
            return val;
        }
    }

    function bindElementEventHandler(element, property, data) {
        data = data.trim();
        let parsed = data;
        if (data.startsWith("{")) parsed = eval("(" + data + ")");
        element.addEventListener(property.toLowerCase().replace("on", ""), () => exo.action(parsed));
    }

    function createStyleFunction(element, property, format) {
    	let [cssPropName, mods] = property.replace("@css.", "").split(":"); // @css is less intuitive then @style but style is a possible element attribute...
    	if(mods) {
    		mods = mods.split(',');
    	}

    	return () => {
    		element.style[cssPropName] = getValue(format, mods);
    	};
    }

    function createClassFunction(element, property, format) {
        let [className, mods] = property.replace("@class.", "").split(":"); // first value of array will be the className and second value (optional) will be a comma seperated list of modifiers
        if(mods) {
        	mods = mods.split(',');
        }

        return () => {
            if (format.startsWith("!")) {
                if (!getValue(format.slice(1), mods)) {
                    element.classList.add(className);
                } else {
                    element.classList.remove(className);
                }
            } else {
                if (getValue(format, mods)) {
                    element.classList.add(className);
                } else {
                    element.classList.remove(className);
                }
            }
        };
    }

    function createContentFunction(element, property, format, variables) {
        return () => {
            let content = format;

            for (let variable of variables) {
                let [varName, mods] = variable.slice(1,-1).split(":") // first value of array will be the variable and second value (optional) will be a comma seperated list of modifiers
                if(mods) {
                    mods = mods.split(","); // extract a list of modifiers to apply
                    // even if the var is somethings like this: {system.version:} it will work since applyMods() will verify mods is an array
                }

                let value = getValue(varName, mods);
                if (typeof value == 'undefined' || value == null) value = "no";

                content = content.split(variable).join(value);
            }

            if (property.startsWith("@")) {
                element.setAttribute(property.slice(1), content);
            } else {
                element[property] = content;
            }
        };
    }

    function updateGeneratedData() {
        exo._update({
            'time': new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }),
            'time.withSeconds': new Date().toLocaleTimeString()
        });
    }

    function stripModifiersFromContent(arr) {
    	// we need addTo() to support content binding with modifiers
    	return arr.map((item) => {
    		const stripped = item
    			.slice(1,-1) // remove '{' and '}'
    			.split(':')[0] // remove everything beyond ':' if it exists

    		return '{' + stripped + '}'; // we need to re-add {} to make it work with addTo()
    	}); // strip modifiers from value
    }
    
    function addTo(object, element, variables) {
        for (let variable of variables) {
            let key = variable.replace("{", "").replace("}", "");
            if (!object[key]) {
                object[key] = [element];
            } else {
                for (let objElement of object[key]) {
                    if (objElement === element) return;
                }
                
                object[key].push(element);
            }
        }
    }

    function callHandlers(name, data) {
        if (!eventHandlers[name]) return;

        for (let handler of eventHandlers[name]) {
            handler(data);
        }
    }
    
    function getTextNodes(element) {
        return Array.from(element.childNodes).filter(child => child.nodeType === Node.TEXT_NODE);
    }

    let exo = (selector) => {
        let elements = document.querySelectorAll(selector);

        elements.bindContent = (format) => {
            let variables = format.match(formatRe);
            if (variables.length == 0) return;

            for (let element of elements) {
                if (!element.exo) element.exo = {};
                let fn = createContentFunction(element, 'innerText', format, variables);
                addTo(boundFunctions, fn, variables);
                fn();
            }
        };

        elements.autobind = () => {
            for (let element of elements) {
                for (let attribute of element.attributes) {
                    if (!attribute.name.startsWith("@")) continue;

                    if (attribute.name.startsWith("@on")) {
                        bindElementEventHandler(element, attribute.name.substring(1), attribute.value);
                        continue;
                    }

                    if (attribute.name.startsWith("@class.")) {
                      let fn = createClassFunction(element, attribute.name, attribute.value);
                      addTo(boundFunctions, fn, [attribute.value.replace("!", "")]);
                      fn();
                      continue;
                    }

                    if (attribute.name.startsWith("@css.")) {
	                    let fn = createStyleFunction(element, attribute.name, attribute.value);
	                    addTo(boundFunctions, fn, [attribute.value]);
	                    fn();
	                    continue;	
                    }

                    let variables = attribute.value.match(formatRe);
                    if (!variables || variables.length == 0) continue;
                    
                    let fn = createContentFunction(element, attribute.name, attribute.value, variables);
                    addTo(boundFunctions, fn, stripModifiersFromContent(variables));
                    fn();
                }

                if (element.tagName == 'SCRIPT' || element.tagName == 'STYLE' || element.tagName == 'NOSCRIPT' || element.tagName == 'IFRAME') continue;
                
                let textNodes = getTextNodes(element);
                if (!textNodes || textNodes.length == 0) continue;
                
                for (let textNode of textNodes) {
                    let variables = textNode.nodeValue.match(formatRe);
                    if (!variables || variables.length == 0) continue;

                    if (!element.exo) element.exo = {};
                    let fn = createContentFunction(textNode, 'nodeValue', textNode.nodeValue, variables);
                    addTo(boundFunctions, fn, stripModifiersFromContent(variables));
                    fn();
                }
            }
        };

        return elements;
    };
    
    exo._update = (data) => {
        let fnsToUpdate = [];
        for (let key of Object.keys(data)) {
            if (currentData[key] === data[key]) {
                delete data[key];
                continue;
            }

            currentData[key] = data[key];
            callHandlers("update." + key, data[key]);

            if (boundFunctions[key]) {
                for (let fn of boundFunctions[key]) {
                    let contains = false;
                    for (let f of fnsToUpdate) {
                        if (fn === f) {
                            contains = true;
                            break;
                        }
                    }

                    if (!contains) {
                        fnsToUpdate.push(fn);
                    }
                }
            }
        }

        for (let fn of fnsToUpdate) {
            fn();
        }

        callHandlers("update", data);
    };

    exo.bind = (event, handler) => {
        if (!eventHandlers[event]) {
            eventHandlers[event] = [handler];
            return;
        }

        eventHandlers[event].push(handler);
    };

    exo.action = (action) => {
        if (!action) return;
        let name = action;
        if (typeof name === "object") name = action['action'];

        if (actions[name]) return actions[name](action);
        if (!window['webkit']) return;
        
        if (typeof action === "object" || typeof action === "string") {
            webkit.messageHandlers.action.postMessage(action);
        }
    };

    exo.setFilter = (name, filter) => {
        filters[name] = filter;
    };

    exo.setOption = (name, value) => {
        options[name] = value;
    };

    exo.setAction = (name, value) => {
        actions[name] = value;
    };

    exo.get = (name, skipFilters) => {
        if (skipFilters) {
            return currentData[name];
        } else {
            return getValue(name);
        }
    };

    exo.set = (name, value) => {
        exo._update({
            [name]: value
        });
    };

    exo.log = (message) => {
        exo.action({
            action: "log",
            message: message
        });
    };

    exo.init = () => {
        if (options['autobind']) {
            exo('body *').autobind();
        }
    };

    exo.setModifier = (name, value) => {
        modifiers[name] = value;
    };

    updateGeneratedData();
    setInterval(updateGeneratedData, 1000);
    exo.action("requestUpdate");

    return exo;
})();
