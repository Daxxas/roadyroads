class SoundManager {
    SoundFile music;
    SoundFile carCrash;
    
    SoundManager(SoundFile music, SoundFile carCrash) {
      this.music = music;
      this.carCrash = carCrash;
    }

    
    public void StartMusic() {
      music.loop(); 
    }
    
    public void StopMusic() {
      music.stop();
    }
    
    public void PlayCrash() {
      carCrash.play();
    }
}
