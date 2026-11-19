document.querySelectorAll('a[href^="#"]').forEach(a=>a.addEventListener('click',()=>document.querySelector(a.getAttribute('href'))?.scrollIntoView({behavior:'smooth'})));
document.querySelectorAll('form').forEach(f=>f.addEventListener('submit',()=>{const b=f.querySelector('button[type="submit"]');if(b){b.disabled=true;b.textContent='Processando...';}}));
