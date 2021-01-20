const selectOutcome = () => {
  const selects = document.querySelectorAll(".square");
  selects.forEach((outcome)=>{
    outcome.addEventListener("click",(event) => {
  $('input[type="checkbox"]').on('change', function() {
   $(this).siblings('input[type="checkbox"]').not(this).prop('checked', false);
});
      const result = event.currentTarget.dataset.outcome;
      console.log(result);
      const id = event.currentTarget.parentNode.dataset.id;
      console.log(id);
      const box = event.currentTarget.checked;
      console.log(box);
      const url = 'store_outcome?result='+result+'&match='+id+'&box='+box
      fetch(url)
        .then(response => response.json())
        .then((data) => {
      console.log(data);
      });
    });
  });
}

const selectOutcomeBe = () => {
  const selects = document.querySelectorAll(".square_b2e");
  selects.forEach((outcome)=>{
    outcome.addEventListener("click",(event) => {
  $('input[type="checkbox"]').on('change', function() {
   $(this).siblings('input[type="checkbox"]').not(this).prop('checked', false);
});
      const result = event.currentTarget.dataset.outcome;
      console.log(result);
      const id = event.currentTarget.parentNode.dataset.id;
      console.log(id);
      const box = event.currentTarget.checked;
      console.log(box);
      const url = 'store_outcome_b2e?result='+result+'&match='+id+'&box='+box
      fetch(url)
        .then(response => response.json())
        .then((data) => {
      console.log(data);
      });
    });
  });
}

const selectOutcomeUnder = () => {
  const selects = document.querySelectorAll(".square_under");
  selects.forEach((outcome)=>{
    outcome.addEventListener("click",(event) => {
  $('input[type="checkbox"]').on('change', function() {
   $(this).siblings('input[type="checkbox"]').not(this).prop('checked', false);
});
      const result = event.currentTarget.dataset.outcome;
      console.log(result);
      const id = event.currentTarget.parentNode.dataset.id;
      console.log(id);
      const box = event.currentTarget.checked;
      console.log(box);
      const url = 'store_outcome_under?result='+result+'&match='+id+'&box='+box
      fetch(url)
        .then(response => response.json())
        .then((data) => {
      console.log(data);
      });
    });
  });
}

const selectOutcomeStriker1 = () => {
  const selects = document.querySelectorAll(".square_striker1");
  selects.forEach((outcome)=>{
    outcome.addEventListener("click",(event) => {
  $('input[type="checkbox"]').on('change', function() {
   $(this).siblings('input[type="checkbox"]').not(this).prop('checked', false);
});
      const result = event.currentTarget.dataset.outcome;
      console.log(result);
      const id = event.currentTarget.parentNode.dataset.id;
      console.log(id);
      const box = event.currentTarget.checked;
      console.log(box);
      const url = 'store_outcome_striker1?result='+result+'&match='+id+'&box='+box
      fetch(url)
        .then(response => response.json())
        .then((data) => {
      console.log(data);
      });
    });
  });
}

const validePanier = () => {
  const panier = document.getElementById('panier');
  panier.addEventListener("click", (event) =>{
    console.log("click")
    const player = document.getElementById('season_player').value;
    fetch('confirm_pending?player='+player)
    .then(response => response.json())
    .then((data) => {
    console.log(data);
    });
  })
}

const calculate = () => {
  document.querySelector(".info").addEventListener("change", function(e) {
  const tgt = e.target;
  let z = 0
  if (tgt.classList.contains("square")) {
    const parent = tgt.closest(".displaysquares");
    var x = document.querySelectorAll(".square:checked").length; console.log(x);
    z += x
    document.querySelector(".plus").innerHTML = z;
  } else {
    const parent = tgt.closest(".b2e");
    var y = document.querySelectorAll(".square_b2e:checked").length; console.log(y);
    z += y
    document.querySelector(".plus").innerHTML = z;
    }
  })
}

// const calculateButs = () => {
//   document.querySelector(".info").addEventListener("change", function(e) {
//   const tgt = e.target;
//   if (tgt.classList.contains("square_b2e")) {
//     const parent = tgt.closest(".b2e");
//     var y = document.querySelectorAll(".square_b2e:checked").length; console.log(y);
//     document.querySelector(".plus").innerHTML = y ;
//     }
//   })
// }

export { selectOutcome, selectOutcomeBe, selectOutcomeUnder, selectOutcomeStriker1, validePanier, calculate};


