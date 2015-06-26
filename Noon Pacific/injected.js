var DesktopHelper = {
  init: function() {
    var controller = document.querySelector("[ng-controller=AudioCtrl]");
    this.scope = angular.element(controller).scope();
  },

  getCurrentTrackObj: function() {
    return this.scope.$parent.currentTrack;
  },

  isPlaying: function() {
    return this.scope.audio.state == "playing";
  },

  play: function() {
    if (this.isPlaying()) {
      console.log("Already playing");
      return;
    }
    this.scope.PlayPauseClick();
  },

  pause: function() {
    if (!this.isPlaying()) {
      console.log("Already paused");
      return;
    }
    this.scope.PlayPauseClick();
  },

  next: function() {
    this.scope.audio.PlayNextSong();
  },

  previous: function() {
    this.scope.audio.PlayPreviousSong();
  }
}

DesktopHelper.init();
window.DesktopHelper = DesktopHelper;