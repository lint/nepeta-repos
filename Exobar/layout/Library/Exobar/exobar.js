window.exo.bind('update.exobar.modern', (modern) => {
  let burnInProtectionCss = document.getElementById('oledBurnInProtectionCss');
  if (window.exo.get('exobar.disableBurnInProtection')) {
    burnInProtectionCss.disabled = false;
  } else {
    burnInProtectionCss.disabled = !modern;
  }
});

window.exo.bind('update.exobar.disableBurnInProtection', (disable) => {
  let burnInProtectionCss = document.getElementById('oledBurnInProtectionCss');
  if (disable) {
    burnInProtectionCss.disabled = true;
  } else {
    burnInProtectionCss.disabled = !window.exo.get('exobar.modern');
  }
});