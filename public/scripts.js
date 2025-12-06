const apiUrl = "http://127.0.0.1:3000/patterns";

// Load patterns, optionally filtered by search term
async function loadPatterns(searchTerm = "") {
  console.log("loadPatterns called with searchTerm:", searchTerm);

  let url = apiUrl;
  if (searchTerm.trim() !== "") {
    url += `?q=${encodeURIComponent(searchTerm)}`;
  }

  try {
    const response = await fetch(url, {
      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' }
    });

    if (!response.ok) {
      console.error("Failed to fetch patterns:", response.statusText);
      return;
    }

    const data = await response.json();
    console.log("Patterns fetched:", data);

    let curPat = '<div><table id="cards">';
    for (let i = 0; i < data.length; i++) {
      const p = data[i];
      curPat += `<tr id="pattern-${p.id}">`;
      curPat += `<td>`;
      curPat += `<strong><u>Title: </u></strong>${p.title}<br>`;
      curPat += `<strong>Source/Website Name: </strong>${p.source}<br>`;
      curPat += `<strong>Link to full Pattern: </strong><a href="${p.link}" target="_blank" rel="noopener">${p.link}</a><br>`;
      curPat += `<strong>Users ID: </strong>${p.user_id}<br>`;
      curPat += `<strong>Rating (Out of 5): </strong>${p.rating}<br>`;
      curPat += `<strong>Difficulty Level (Out of 5): </strong>${p.difficulty}<br>`;
      curPat += `<strong>Made: </strong>${p.made}<br>`;
      curPat += `<strong>Tags: </strong>${p.tags}<br>`;
      curPat += `<strong>Yarn Weight Used: </strong>${p.yarn_weight}<br>`;
      curPat += `<strong>Main Stitch Type: </strong>${p.stitch_type}<br>`;
      curPat += `<strong>Project Size: </strong>${p.size}<br>`;
      curPat += `<strong>Estimated Yarn Needed: </strong>${p.yarn_estimate} meters<br>`;
      curPat += `<strong>Notes: </strong>${p.notes}<br><br>`;
      curPat += `<button onclick="deletePattern(${p.id})">Delete</button> `;
      curPat += `<button onclick="editPattern(${p.id})">Edit</button>`;
      curPat += `</td>`;
      curPat += `</tr>`;
    }
    curPat += '</table></div>';

    document.getElementById('patterns').innerHTML = curPat;

  } catch (error) {
    console.error("Error loading patterns:", error);
  }
}

// Submit new pattern handler
document.getElementById('newPatternForm').addEventListener('submit', async (e) => {
  e.preventDefault();
  const formData = Object.fromEntries(new FormData(e.target));

  const res = await fetch(apiUrl, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(formData),
  });

  if (res.ok) {
    e.target.reset();
    toggleForm();
    loadPatterns();
  } else {
    const err = await res.json();
    alert(err.errors ? err.errors.join("\n") : "Failed to create pattern");
  }
});

// Delete pattern
async function deletePattern(id) {
  if (confirm("Delete this pattern?")) {
    const res = await fetch(`${apiUrl}/${id}`, { method: "DELETE" });
    if (res.ok) {
      console.log("Pattern Deleted");
      loadPatterns();
    } else {
      console.error("Failed to delete pattern", await res.text());
    }
  }
}

// Edit pattern: load data and show form in place
async function editPattern(id) {
  console.log("editPattern called for id:", id);

  const res = await fetch(`${apiUrl}/${id}`, { headers: { Accept: "application/json" } });
  if (!res.ok) {
    alert("Failed to load pattern for editing");
    return;
  }
  const data = await res.json();
  const pattern = data.pattern;

  const card = document.querySelector(`#pattern-${id}`);
  if (!card) return;

  // Use unique IDs on inputs to avoid conflicts
  card.innerHTML = `
    <form id="editForm-${id}" class="edit-form">
      <label for="title-${id}">Title: </label>
      <input type="text" id="title-${id}" name="title" value="${pattern.title}" required /><br />
      
      <label for="source-${id}">Source/Website Name:</label>
      <input type="text" id="source-${id}" name="source" value="${pattern.source}" required /><br />
      
      <label for="link-${id}">Link to full Pattern: </label>
      <input type="url" id="link-${id}" name="link" value="${pattern.link || ''}" /><br />
      
      <label for="user_id-${id}">User's ID: </label>
      <input type="number" id="user_id-${id}" name="user_id" value="${pattern.user_id}" required /><br />
      
      <label for="rating-${id}">Rating (Out of 5): </label>
      <input type="number" id="rating-${id}" name="rating" step="0.5" value="${pattern.rating || 1}" required /><br />
      
      <label for="difficulty-${id}">Difficulty Level (Out of 5): </label>
      <input type="number" id="difficulty-${id}" name="difficulty" step="0.5" value="${pattern.difficulty || 1}" required /><br />
      
      <label for="made-${id}">How Many Made? </label>
      <input type="number" id="made-${id}" name="made" value="${pattern.made || 0}" /><br />
      
      <label for="tags-${id}">Tags: </label>
      <input type="text" id="tags-${id}" name="tags" required value="${pattern.tags}" /><br />
      
      <label for="yarn_weight-${id}">Yarn Weight Used:</label>
      <input type="text" id="yarn_weight-${id}" name="yarn_weight" list="yarn-weights"  value="${pattern.yarn_weight || 'medium'}" required />
      <datalist id="yarn-weights">
          <option value="lace"></option>
          <option value="light"></option>
          <option value="medium"></option>
          <option value="bulky"></option>
          <option value="super bulky"></option>
        </datalist><br />
      
      <label for="stitch_type-${id}">Main Stitch Type:</label>
      <input type="text" id="stitch_type-${id}" name="stitch_type" list="stitch-type" value="${pattern.stitch_type || 'single crochet'}" required />
      <datalist id="stitch-type">
          <option value="single crochet"></option>
          <option value="double crochet"></option>
          <option value="half double crochet"></option>
          <option value="knit"></option>
          <option value="purl"></option>
        </datalist><br />
      
      <label for="size-${id}">Project Size:</label>
      <input type="text" id="size-${id}" name="size" list="size-opt" value="${pattern.size || 'medium'}" required />
      <datalist id="size-opt">
          <option value="small"></option>
          <option value="medium"></option>
          <option value="large"></option>
        </datalist><br />
      
      <label for="notes-${id}">Notes: </label>
      <input type="text" id="notes-${id}" name="notes" value="${pattern.notes || ''}" /><br /><br />
      
      <button type="submit" onclick="saveEdit(${id})" >Save Changes</button>
      <button type="button" onclick="cancelEdit(${id})">Cancel</button>
    </form>
  `;

  console.log("Edit form HTML inserted for pattern id:", id);
}

// Cancel edit reloads patterns view
function cancelEdit(id) {
  loadPatterns();
}

async function saveEdit(id) {
  // Collect values explicitly by id
  const updatedData = {
    title: document.getElementById(`title-${id}`).value,
    source: document.getElementById(`source-${id}`).value,
    link: document.getElementById(`link-${id}`).value,
    user_id: parseInt(document.getElementById(`user_id-${id}`).value),
    rating: parseFloat(document.getElementById(`rating-${id}`).value),
    difficulty: parseFloat(document.getElementById(`difficulty-${id}`).value),
    made: parseInt(document.getElementById(`made-${id}`).value) || 0,
    tags: document.getElementById(`tags-${id}`).value,
    yarn_weight: document.getElementById(`yarn_weight-${id}`).value,
    stitch_type: document.getElementById(`stitch_type-${id}`).value,
    size: document.getElementById(`size-${id}`).value,
    notes: document.getElementById(`notes-${id}`).value,
  };

  try {
    const updateRes = await fetch(`${apiUrl}/${id}`, {
      method: "PUT",
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ pattern: updatedData }), // wrapping in pattern object if your Rails expects it
    });

    if (updateRes.ok) {
      loadPatterns();
      console.log("Pattern updated successfully");
    } else {
      const errorData = await updateRes.json();
      console.error("Update failed:", errorData);
      alert("Validation failed:\n" + (errorData.errors ? errorData.errors.join("\n") : "Unknown error"));
    }
  } catch (error) {
    console.error("Error in saveEdit:", error);
  }
}

// Toggle add new pattern form visibility
function toggleForm() {
  document.getElementById("add-new").classList.toggle("hidden");
  document.getElementById("patterns").classList.toggle("hidden");
}

document.getElementById("toggleForm").addEventListener("click", toggleForm);

document.getElementById("cancelForm").addEventListener("click", () => {
  toggleForm();
  document.getElementById("newPatternForm").reset();
});

document.addEventListener("DOMContentLoaded", () => {
  console.log("DOM loaded");

  document.getElementById("searchBox").addEventListener("input", (e) => {
    loadPatterns(e.target.value);
  });

  loadPatterns();
});
