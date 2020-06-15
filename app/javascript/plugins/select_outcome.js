const selectOutcome = () => {
  const selects = document.querySelectorAll(".square");
  selects.forEach((outcome)=>{
    outcome.addEventListener("click",(event) =>{
      const result = event.currentTarget.dataset.outcome;
      console.log(result);
      const id = event.currentTarget.parentNode.dataset.id;
      console.log(id);

      fetch('store_outcome') //store_outcome?result='+result+'&match='+id
        .then(response => response.JSON())
        .then((data) => {
      console.log(data);
      });
    });
  });
}

export {selectOutcome};
