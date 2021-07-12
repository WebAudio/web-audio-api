// This replaces the contents of |divID| with an unordered list of all the
// amendment boxes with a prefix of |prefix|.  Each item of the list will be of
// the form "label n", where "label" is the specified label to use via |label|.
// "n" is just a sequential number starting at 1.
//
// Example usage where we want a list of all the changes whose id begins with
// "c2361".
//
// <div id="change-list-2361">
//  <script>ListAmendments("c2361", "Correction", "change-list-2361")</script>
// </div>
function ListAmendments(prefix, label, divID) {
  // Find all the nodes whose id starts with |prefix|.

  // TODO: Needs error checking!
  let nodes = document.querySelectorAll(`*[id^="${prefix}"]`);
  // Find the div element which will be replaced by the unordered list.
  let div = document.getElementById(divID);

  // Create the unordered list
  let text = '<ul>';
  let index = 1;
  nodes.forEach(x => {
    text += `<li><a href="#${x.id}">${label} ${index}</a></li>`;
    ++index;
    // Insert buttons for prev and next change
    InsertButtons(x);
  });
  text += '</ul>';

  div.innerHTML = text;
}

// Search for the class "amendment-buttons", and replace the contents of the div
// with a set of buttons which link to the previous and next related amendment.

function InsertButtons(node) {
  let list = node.getElementsByClassName("amendment-buttons");

  // We only add buttons to the first class inside the node.
  if (list && list.length > 0) {
    let matches = node.id.match(/([ac]\d+)-(\d+)/);
    let changeID = matches[1];
    let changeNum = parseInt(matches[2]);
    // Create buttons.
    let text = "";
    if (changeNum > 1) {
      text += `<button onclick='location.href="#${changeID}-${changeNum-1}"'>Previous</button>`;
    }

    if (document.getElementById(changeID + "-" + (changeNum + 1))) {
      text += `<button onclick='location.href="#${changeID}-${changeNum+1}"'>Next</button>`;
    }

    list[0].innerHTML = text;
  }
}
