const studentList = document.querySelector('#student-list');
const form = document.querySelector('#add-student-form');
const VAL = document.getElementById('select1').options[document.getElementById('select1').selectedIndex].value;

var complete = 1;
// create element & render cafe


function badFormat(){
    return (
    (form.name.value != "")  &&
    (form.lname.value != "") &&    
    (form.id.value != "")  &&
    (form.city.value != "Campus") &&
    (form.period.value != "Semestre"))
    ? true : false;
}
function renderStudent(doc){
    let li = document.createElement('tr');
    let name = document.createElement('td');
    let lname = document.createElement('td');
    let id = document.createElement('td');
    let city = document.createElement('td');
    let period = document.createElement('td');
    // let work = document.createElement('td');
    let td = document.createElement('td');
    let cross = document.createElement('button');

    li.setAttribute('data-id', doc.id);
    name.textContent = doc.data().Name;


    lname.textContent = doc.data().Last_name;
    period.textContent = doc.data().Current_period;
    // work.textContent = doc.data().Workid;
    id.textContent = doc.data().Id;
    // name.addClass('Hola');
    city.textContent = doc.data().Campus_id;
    cross.textContent = 'Eliminar';
    cross.classList.add("btn");
    cross.classList.add("btn-outline-primary");

    li.appendChild(name);
    li.appendChild(lname);
    li.appendChild(id);
    li.appendChild(city);
    li.appendChild(period);
    // li.appendChild(work);
    td.appendChild(cross);
    li.appendChild(cross);
    studentList.appendChild(li);

    // deleting data
    cross.addEventListener('click', (e) => {
        e.stopPropagation();
        var result = confirm("Estas seguro de que deseas eliminar a " +
        doc.data().Name + " ");
        if (result) {
            //Logic to delete the item
        let id = e.target.parentElement.getAttribute('data-id');
        db.collection('Users').doc(id).delete();
        db.collection('Enrolled_workshop').where('Student_id', "==", doc.data().Id)
            .get()
            .then((querySnapshot) => {
                querySnapshot.forEach((doc) => {
                    // doc.data() is never undefined for query doc snapshots
                    window.alert(doc.id, " => ", doc.data());
                });
            })
            .catch((error) => {
                console.log("Error getting documents: ", error);
            });
        }
        
        
    });

}

// getting data
db.collection('Users').where("Role","==","Student").get().then(snapshot => {
    snapshot.docs.forEach(doc => {
        renderStudent(doc);
    });
});

// Function that add data to the server
form.addEventListener('submit', (e) => {
    e.preventDefault();

    if(badFormat()){
        // window.alert(form.name.value);
        db.collection('Users').add({
            Name: form.name.value,
            Last_name: form.lname.value,
            Id: form.id.value,
            Campus_id: form.city.value,
            Current_period: form.period.value,
            Role: "Student"
        });
        form.name.value = '';
        form.lname.value = '';
        form.id.value = '';
        form.city.value = '';
        // form.workid.value = '';
        form.period.value = '';
        window.alert("Alumno ingresado exitosamente");
    }else{
        window.alert("Formato incorrecto");
    }
    
    
});


function Refresh() {
    window.parent.location = window.parent.location.href;
}

function ExportToExcel(type, fn, dl) {
    var elt = document.getElementById('tbl_exporttable_to_xls');
    var wb = XLSX.utils.table_to_book(elt, { sheet: "sheet1" });
    return dl ?
        XLSX.write(wb, { bookType: type, bookSST: true, type: 'base64' }) :
        XLSX.writeFile(wb, fn || ('EstudiantesPrepaNet.' + (type || 'xlsx')));
}


function myFunction() {
    var input, filter, table, tr, td, i, txtValue;
    input = document.getElementById("in");
    filter = input.value.toUpperCase();
    table = document.getElementById("myTable");
    tr = table.getElementsByTagName("tr");
    for (i = 0; i < tr.length; i++) {
      td = tr[i].getElementsByTagName("td")[0];
      if (td) {
        txtValue = td.textContent || td.innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
          tr[i].style.display = "";
        } else {
          tr[i].style.display = "none";
        }
      }       
    }
  }

function Upload() {
    var fileUpload = document.getElementById("fileUpload");
    var regex = /^([a-zA-Z0-9\s_\.-:])+(.csv|.txt)$/;
    window.alert("Alumno ingresado exitosamente");
    if (true) {
        if (typeof (FileReader) != "undefined") {
            var reader = new FileReader();
            reader.onload = function (e) {
                var rows = e.target.result.split("\n");
                for (var i = 0; i < rows.length; i++) {
                    var cells = rows[i].split(",");
                    if (cells.length > 1 && i > 0) {
                        db.collection('Users').add({
                            Name: cells[0],
                            Last_name: cells[1],
                            Id: cells[2],
                            Campus_id: cells[3],
                            // Workshop_id: form.workid.value,
                            Current_period: cells[4],
                            Role: "Student"
                        });
                    }
                }
            }
            reader.readAsText(fileUpload.files[0]);
        } else {
            alert("This browser does not support HTML5.");
        }
    } else {
        alert("Please upload a valid CSV file.");
    }
}