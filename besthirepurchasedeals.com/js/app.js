// ---- Monthly payment calculator (illustrative estimate only) ----
(function () {
  const price = document.getElementById('calc-price');
  const deposit = document.getElementById('calc-deposit');
  const apr = document.getElementById('calc-apr');
  const term = document.getElementById('calc-term');
  const termValue = document.getElementById('calc-term-value');

  const outMonthly = document.getElementById('calc-monthly');
  const outFinanced = document.getElementById('calc-financed');
  const outInterest = document.getElementById('calc-interest');
  const outTotal = document.getElementById('calc-total');

  if (!price || !deposit || !apr || !term) return;

  const gbp = (n) => '£' + Math.round(n).toLocaleString('en-GB');

  function calculate() {
    const p = Math.max(0, parseFloat(price.value) || 0);
    const d = Math.max(0, Math.min(parseFloat(deposit.value) || 0, p));
    const annualRate = Math.max(0, parseFloat(apr.value) || 0) / 100;
    const months = parseInt(term.value, 10) || 48;

    termValue.textContent = months;

    const financed = p - d;
    const monthlyRate = annualRate / 12;

    let monthlyPayment;
    if (monthlyRate === 0) {
      monthlyPayment = financed / months;
    } else {
      const factor = Math.pow(1 + monthlyRate, months);
      monthlyPayment = (financed * monthlyRate * factor) / (factor - 1);
    }

    const totalPayable = monthlyPayment * months + d;
    const totalInterest = totalPayable - p;

    outMonthly.textContent = gbp(monthlyPayment);
    outFinanced.textContent = gbp(financed);
    outInterest.textContent = gbp(Math.max(0, totalInterest));
    outTotal.textContent = gbp(totalPayable);
  }

  [price, deposit, apr, term].forEach((el) => {
    el.addEventListener('input', calculate);
  });
  calculate();
})();

// ---- Comparison table filter pills ----
(function () {
  const buttons = document.querySelectorAll('.filter-bar button');
  const rows = document.querySelectorAll('.deals-table tbody tr');
  if (!buttons.length || !rows.length) return;

  buttons.forEach((btn) => {
    btn.addEventListener('click', () => {
      buttons.forEach((b) => b.classList.remove('is-active'));
      btn.classList.add('is-active');
      const filter = btn.dataset.filter;
      rows.forEach((row) => {
        const cats = (row.dataset.category || '').split(' ');
        row.style.display = filter === 'all' || cats.includes(filter) ? '' : 'none';
      });
    });
  });
})();
