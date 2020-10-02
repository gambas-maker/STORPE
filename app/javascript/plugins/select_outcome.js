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
  if (tgt.classList.contains("square")) {
    const parent = tgt.closest(".displaysquares");
    var x = document.querySelectorAll(".square:checked").length; console.log(x);
    document.querySelector(".plus").innerHTML = x;
    }
  })
}

export { selectOutcome, validePanier, calculate};


