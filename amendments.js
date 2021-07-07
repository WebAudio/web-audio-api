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
  let nodes = document.querySelectorAll(`*[id^="${prefix}"]`);
  // Find the div element which will be replaced by the unordered list.
  let div = document.getElementById(divID);

  // Create the unordered list
  let text = '<ul>';
  let index = 1;
  nodes.forEach(x => {
      text += `<li><a href="#${x.id}">${label} ${index}</a></li>`;
      ++index;
  });
  text += '</ul>';

  div.innerHTML = text;
}
