function run(): void {
  window["Elm"]?.Multimedia?.init();
  const shellImages = document.querySelectorAll<HTMLElement>(":is(#Shell, #Restrictive) img");
  window.addEventListener("mousemove", (e) => {
    shellImages.forEach(shell => {
      shell.style.filter = `hue-rotate(${~~(e.clientX / 2 + e.clientY / 3)}deg)`;
    });
  })
}

run();

export { };
