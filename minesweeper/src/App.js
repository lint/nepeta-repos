import React, { Component } from 'react';
import './App.css';
import { isMobile } from "react-device-detect";

class App extends Component {
  constructor() {
    super();

    this.state = {
      width: 10,
      height: 10,
      bombs: 10,
      board: [],
      input: [],
      generated: false,
      started: false,
      uncover: false,
      gameOver: 0,
      isFlagging: false,
    };

    window.addEventListener('hashchange', this.parseHash.bind(this));
  }

  parseHash() {
    let width = 10;
    let height = 10;
    let bombs = 10;
    if (window.location.hash) {
      var query = {};
      var pairs = (window.location.hash[0] === '#' ? window.location.hash.substr(1) : window.location.hash).split('&');
      for (var i = 0; i < pairs.length; i++) {
          var pair = pairs[i].split('=');
          query[decodeURIComponent(pair[0])] = decodeURIComponent(pair[1] || '');
      }

      if (query['w']) width = +query['w'];
      if (query['h']) height = +query['h'];
      if (query['b']) bombs = +query['b'];
    }

    this.setState({
      width: width,
      height: height,
      bombs: bombs,
      generated: false
    }, this.generateBoard);
  }

  componentDidMount() {
    this.parseHash();
  }

  componentDidUpdate() {
    if (this.state.uncover !== false) {
      this.uncover(this.state.uncover[0], this.state.uncover[1]);
      this.setState({
        uncover: false
      });
    }

    this.checkVictoryConditions();
  }

  generateBoard(avoid) {
    let width = this.state.width;
    let height = this.state.height;
    let bombs = this.state.bombs;

    /* Prepare board */
    let newBoard = new Array(width);
    let newInput = new Array(width);
    for (let i = 0; i < width; i++) {
      newBoard[i] = new Array(height);
      newInput[i] = new Array(height);
    }

    /* Generate bombs */
    for (let i = 0; i < bombs; i++) {
      let x = Math.floor(Math.random() * width);
      let y = Math.floor(Math.random() * height);

      if (newBoard[x][y] === -1 || (avoid && x === avoid[0] && y === avoid[1])) {
        i--;
      }
      
      newBoard[x][y] = -1;
    }
    
    /* Generate numbers */
    for (let x = 0; x < width; x++) {
      for (let y = 0; y < height; y++) {
        if (newBoard[x][y] === -1) continue;
        
        let count = 0;
        for (let nx = (x-1>0) ? x-1 : 0; nx <= ((x+1<width) ? x+1 : width - 1); nx++) {
          for (let ny = (y-1>0) ? y-1 : 0; ny <= ((y+1<height) ? y+1 : height - 1); ny++) {
            if (nx === x && ny === y) continue;
            count += (newBoard[nx][ny] === -1);
          }
        }
        newBoard[x][y] = count;
      }
    }

    this.setState({
      board: newBoard,
      input: newInput,
      generated: true,
      started: false,
      uncover: (avoid) ? avoid : false,
      gameOver: 0,
      isFlagging: false,
    });
  }

  getText(value, input) {
    if (this.state.gameOver === 0) {
      switch (input) {
        case 1:
          break;
        case 2:
          return '🚩';
        default:
          return '\u00A0';
      }
    }

    switch (value) {
      case -1:
        return '💣';
      case 0:
        return '\u00A0';
      default:
        return value;
    }
  }

  uncover(x, y) {
    if (this.state.isFlagging) {
      this.flag(x, y);
      return;
    }

    if (this.state.input[x][y] > 0) return;

    if (!this.state.started && this.state.board[x][y] === -1) {
      this.generateBoard([x, y]);
      return;
    }

    let newInput = this.state.input;
    newInput[x][y] = 1;

    switch (this.state.board[x][y]) {
      case 0:
        for (let nx = (x-1>0) ? x-1 : 0; nx <= ((x+1<this.state.board.length) ? x+1 : this.state.board.length - 1); nx++) {
          for (let ny = (y-1>0) ? y-1 : 0; ny <= ((y+1<this.state.board[nx].length) ? y+1 : this.state.board[nx].length - 1); ny++) {
            if (nx === x && ny === y) continue;
            if (!this.state.board[nx][ny]) {
              this.uncover(nx, ny);
            }
            newInput[nx][ny] = 1;
          }
        }
        break;
      case -1:
        this.gameOver(2);
        break;
      default:
        //nothing
    }

    this.setState({
      input: newInput,
      started: true
    });
  }

  gameOver(type) {
    this.setState({
      gameOver: type
    });
  }

  flag(x, y) {
    if (this.state.input[x][y] === 1) return;

    let newInput = this.state.input;
    if (newInput[x][y] === 2) {
      newInput[x][y] = 0;
    } else {
      newInput[x][y] = 2;
    }

    this.setState({
      input: newInput,
      started: true
    });
  }

  flagEvent(x, y) {
    return (e) => {
      this.flag(x, y);
      e.preventDefault();
    };
  }

  uncoverEvent(x, y) {
    return () => {
      this.uncover(x, y);
    };
  }

  restartEvent() {
    this.generateBoard();
  }

  checkVictoryConditions() {
    if (this.state.gameOver) return;

    let areAllNonBombCellsUncovered = true;
    let areAllBombsMarked = true;
    let areAllFlagsOnBombs = true;

    for (let x = 0; x < this.state.board.length; x++) {
      for (let y = 0; y < this.state.board[x].length; y++) {
        let value = this.state.board[x][y];
        let input = this.state.input[x][y];

        if (value !== -1 && !input) areAllNonBombCellsUncovered = false;
        if (value === -1 && input !== 2) areAllBombsMarked = false; // found an unmarked bomb
        if (value !== -1 && input === 2) areAllFlagsOnBombs = false; // found a flag that's not on a bomb
      }
    }

    if ((areAllNonBombCellsUncovered || areAllBombsMarked) && areAllFlagsOnBombs) this.gameOver(1);
  }

  toggleFlagging() {
    this.setState({
      isFlagging: !this.state.isFlagging
    });
  }

  renderBoard() {
    if (!this.state.generated) return null;
    let elements = [];

    for (let y = 0; y < this.state.height; y++) {
      for (let x = 0; x < this.state.width; x++) {
        let input = this.state.input[x][y];
        let value = this.state.board[x][y];
        let className = "nothing";
        if (input || this.state.gameOver) className = "";

        if (input === 1) {
          className = "uncovered";
          if (value === -1) {
            className += " exploded";
          }
        }
        elements.push((<span className={className}
          onClick={this.uncoverEvent(x, y).bind(this)}
          onContextMenu={this.flagEvent(x, y).bind(this)}
          key={"b" + x + "-" + y}
        >{this.getText(value, input)}</span>));
      }
      elements.push((<br key={"r" + y} />));
    }

    return elements;
  }

  renderPopup() {
    let text = '';
    switch (this.state.gameOver) {
      case 1:
        text = "You've won!";
        break;
      case 2:
        text = "You've lost.";
        break;
      default:
        return null;
    }
    
    return (
      <div class="popup">
        <h2>{text}</h2>
        <button onClick={this.restartEvent.bind(this)}>Try again</button>
      </div>
    );
  }

  render() {
    return (
      <div className="App" onContextMenu={(e) => {e.preventDefault()}}>
        <div className="logo"><img className="logo" src="https://nepeta.me/assets/nepeta.png" alt="Nepeta" /></div>
        <h1>Minesweeper</h1>
        {isMobile ? (<button onClick={this.toggleFlagging.bind(this)}>{this.state.isFlagging ? 'Uncover tiles' : 'Place flags'}</button>) : null}
        <div className="wrap">
          {this.renderPopup()}
          <div className={"board " + (this.state.gameOver ? "gameOver" : "")}>
            {this.renderBoard()}
          </div>
        </div>
      </div>
    );
  }
}

export default App;
