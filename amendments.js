function ListAmendments(prefix, label, divID) {
  let nodes = document.querySelectorAll(`*[id^="${prefix}"]`);
  let div = document.getElementById(divID);

  let text = '<ul>';
  let index = 1;
  nodes.forEach(x => {
      text += `<li><a href="#${x.id}">${label} ${index}</a></li>`;
      ++index;
  });
  text += '</ul>';

  div.innerHTML = text;
}
