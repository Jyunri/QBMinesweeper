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

function quickReset(row, col, bombs) {
  $row = row;
  $col = col;
  $bombs = bombs;
  window.location = "/reset/"+$row+"/"+$col+"/"+$bombs;
}