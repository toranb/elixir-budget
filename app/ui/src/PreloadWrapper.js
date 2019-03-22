const PreloadWrapper = {
  preload() {
    return document.querySelector('script[data-configuration]');
  }
}

export default PreloadWrapper;
