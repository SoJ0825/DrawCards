const btn = document.querySelector('.clickButton');


btn.addEventListener('click', clicknone);

function clicknone() {
  const list = document.querySelector('#slideLeft');
  const card = document.querySelector('.card');
  const cloud = document.querySelector('.cloud');
  const show = document.querySelector('.show');
  const white = document.querySelector('.white');

  card.style.display = 'none';
  cloud.style.display = 'none';
  list.style.animationName = ('slide');
  setTimeout(function () {
    white.style.animationName = ('white');
    list.style.left = ('-738px');
  }, 1500);
}