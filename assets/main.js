
function hideComponent(id) {
	var x = document.getElementById(id);
	if (x.style.display === "none") {
	  x.style.display = "block";
	  x.parentElement.classList.remove('no-print')
	} else {
	  x.style.display = "none";
	  x.parentElement.classList.add('no-print')
	}
  }

function printWeb() {
	window.print();
}