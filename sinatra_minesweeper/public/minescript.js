function checkCell(element) {
  $row = element.getAttribute("row");
  $col = element.getAttribute("col");
  // document.getElementById("log").innerHTML = "Clicked on " + $row + $col;
  window.location = "/check/"+$row+"/"+$col;
}

function flagCell(element) {
  $row = element.getAttribute("row");
  $col = element.getAttribute("col");
  // document.getElementById("log").innerHTML = "(Un)Set flag on " + $row + $col;
  window.location = "/flag/"+$row+"/"+$col;
}

function xray() {
  window.location = "/xray";
}

// prevent context-menu to open
document.oncontextmenu = function() {
  return false;
}

function settings() {
  window.location = "/";
}

function quickReset() {
  window.location = "/reset";
}

function scoreboard(score) {
  var digits = {
    '0': '/0.png',
    '1': '/1.png',
    '2': '/2.png',
    '3': '/3.png',
    '4': '/4.png',
    '5': '/5.png',
    '6': '/6.png',
    '7': '/7.png',
    '8': '/8.png',
    '9': '/9.png',
  };

  return digits[score];
}