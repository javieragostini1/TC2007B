const studentList = document.querySelector('#student-list');
const workshopList = document.querySelector('#workshop-list');
const form = document.querySelector('#add-student-form');
// const VAL = document.getElementById('select1').options[document.getElementById('select1').selectedIndex].value;

var complete = 1;
// create element & render cafe

function goodFormat(){
    return (
        (form.period.value != 'Period') &&
        (form.campus.value != 'Campus') &&
        (form.id.value !='Taller') &&
        (form.start.value < form.end.value)
    )
    ? true : false;
}

function renderStudent(doc){
    let li = document.createElement('tr');
    let name = document.createElement('td');
    let lname = document.createElement('td');
    let id = document.createElement('td');
    let city = document.createElement('td');
    let period = document.createElement('td');
    let work = document.createElement('td');
    let td = document.createElement('td');
    let cross = document.createElement('button');

    li.setAttribute('data-id', doc.id);
    name.textContent = doc.data().Id;

    let date = new Date(doc.data().Start_time);


    lname.textContent = doc.data().Campus_id;
    id.textContent = doc.data().Workshop_id;

    city.textContent = doc.data().Start_time.toDate();

    period.textContent = doc.data().End_time.toDate();
    // name.addClass('Hola');
    work.textContent = doc.data().Period;
    cross.textContent = 'Eliminar';
    cross.classList.add("btn");
    cross.classList.add("btn-outline-primary");

    li.appendChild(name);
    li.appendChild(lname);
    li.appendChild(id);
    li.appendChild(city);
    li.appendChild(period);
    li.appendChild(work);
    td.appendChild(cross);
    li.appendChild(cross);
    studentList.appendChild(li);

    // deleting data
    cross.addEventListener('click', (e) => {
        e.stopPropagation();
        var result = confirm("Estas seguro de que deseas eliminar a " +
        doc.data().Id);
        if (result) {
            //Logic to delete the item
        let id = e.target.parentElement.getAttribute('data-id');
        db.collection('Available_workshop').doc(id).delete();
        db.collection('Enrolled_workshop').where('AWorkshop_id', "==", doc.data().Id)
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


function renderInfo(doc){
    let principal = document.createElement('div');
    principal.setAttribute('work-id', doc.id);

    principal.innerHTML = 
    '<div class="card text-white bg-dark mb-3" >' +
    '<div class="card-header text-dark">'+doc.data().Id+'</div>' + 
    '<div class="card-body">' + 
      '<h5 class="card-title">'+doc.data().Name+'</h5>' + 
      '<p class="card-text">'+doc.data().Description+'</p>'+
    '</div> </div>'
    workshopList.appendChild(principal);

}

// getting data
db.collection('Available_workshop').get().then(snapshot => {
    snapshot.docs.forEach(doc => {
        renderStudent(doc);
    });
});

db.collection('Workshop').get().then(snapshot => {
    snapshot.docs.forEach(doc => {
        renderInfo(doc);
    });
});

// Function that add data to the server
form.addEventListener('submit', (e) => {
    e.preventDefault();

    if(goodFormat()){
        
        var proiodAcronym;        
        if  (form.period.value == "Enero-Abril 2021") {
            periodAcronym = "EA21"
        } else if (form.period.value == "Mayo-Agosto 2021"){
            periodAcronym = "MA21";
        } else {
            periodAcronym = "SD21";
        }
       
        db.collection('Available_workshop').add({
            Period: form.period.value,
            Campus_id: form.campus.value,
            Workshop_id: form.id.value,
            Start_time: firebase.firestore.Timestamp.fromDate(new Date(form.start.value)),
            End_time: firebase.firestore.Timestamp.fromDate(new Date(form.end.value)),
            Id: ("a" + form.id.value + "-" + form.campus.value + "-" + periodAcronym),
        });
        window.alert("Taller agregado correctamente");
        form.period.value = '';
        form.campus.value = '';
        form.id.value = '';
        form.start.value = '';
        form.end.value = '';
        
        
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