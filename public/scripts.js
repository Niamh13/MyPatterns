const apiUrl = "http://127.0.0.1:3000/patterns";

async function loadPatterns(){
             const response = await fetch(apiUrl,
		     {headers: {
			     'Content-Type': 'application/json',
			     'Accept': 'application/json'
		     }})
             var data = await response.json()
             console.log("Loaded patterns: ", data)
             var curPat = '<div><table id="cards">'
              for(var i=0; i < data.length; i++){
                curPat += '<tr><p>'
                curPat += '<strong><u>Title: </strong>' + data[i]['title'] + '</u><br>'
                curPat += '<strong>Source/Website Name: </strong>' + data[i]['source'] + '<br>'
                curPat += '<strong>Link to full Pattern: </strong><a href="' + data[i]['link'] + '">' + data[i]['link'] + '</a><br>'
                curPat += '<strong>Users ID: </strong>' + data[i]['user_id'] + '<br>'
                curPat += '<strong>Rating (Out of 5): </strong>' + data[i]['rating'] +  '<br>'
                curPat += '<strong>Difficulty Level (Out of 5): </strong>' + data[i]['difficulty'] + '<br>'
                curPat += '<strong>Made: </strong>' + data[i]['made'] + '<br>'
                curPat += '<strong>Tags: </strong>' + data[i]['tags'] + '<br>'
                curPat += '<strong>Yarn Weight Used: </strong>' + data[i]['yarn_weight'] + '<br>'
                curPat += '<strong>Main Stitch Type: </strong>' + data[i]['stitch_type'] + '<br>'
                curPat += '<strong>Project Size: </strong>' + data[i]['size'] + '<br>'
                curPat += '<strong>Estimated Yarn Needed: </strong>' + data[i]['yarn_estimate'] + ' meters <br>'
                curPat += '<strong>Notes: </strong>' + data[i]['notes'] + '<br><br>'
                curPat += '<button onclick="deletePattern(' + data[i]['id'] + ')">Delete</button>'
                curPat += '<button onclick="editPattern(' + data[i]['id'] + ')"> Edit </button></p></br></tr>'
             }

	     curPat += '</table></div>'
             console.log("Current Patterns Loaded")
	     document.getElementById('patterns').innerHTML = curPat
        }

document.getElementById('newPatternForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const formData = Object.fromEntries(new FormData(e.target));

  const res = await fetch(apiUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(data),
  });

  if (res.ok) {
    //const newPattern = await res.json();
    e.target.reset();
    toggleForm();
    loadPatterns();

    // Fetch recommendations for that pattern
    /*const recRes = await fetch(`${apiUrl}/${newPattern.id}/recommendations`, {
      headers: { Accept: "application/json" },
    });
    if (recRes.ok) {
      const recommendations = await recRes.json();
      showRecommendations(recommendations);
    }
    loadPatterns();
  } else {
    const err = await res.json();
    alert(err.errors ? err.errors.join("\n") : "Failed to create pattern");
  } */
}});


async function deletePattern(id) {
    if (confirm("Delete this pattern?")) {
        await fetch(`${apiUrl}/${id}`, { method: "DELETE" });
        loadPatterns();
        console.log("Pattern Deleted");
    }
}

async function editPattern(id) {
    const newTitle = prompt("Enter new title:");
    if (!newTitle) return;
    await fetch(`${apiUrl}/${id}`, {
        method: "PUT",
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title: newTitle }),
    });
    loadPatterns();
}

/*function showRecommendations(recs) {
    if (recs.length) {
        const recSection = document.getElementById('recs');
        recSection.className = "recommendations";
        recSection.innerHTML = "<h3>Recommended Patterns</h3>";
        recs.forEach((r) => {
            recSection.innerHTML += `<p>${r.title} (Difficulty: ${r.difficulty})</p>`;
        });
        document.body.appendChild(recSection);
    }
}*/

function toggleForm() {
    document.getElementById("add-new").classList.toggle("hidden");
    document.getElementById("patterns").classList.toggle("hidden");
}

document.getElementById("toggleForm").addEventListener("click", toggleForm);

document.getElementById("cancelForm").addEventListener("click", () => {
    toggleForm();

    document.getElementById("newPatternForm").reset();
});

loadPatterns();

