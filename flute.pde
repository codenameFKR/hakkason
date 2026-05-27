import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.serial.*;

AudioOutput out;
Minim minim;
InstrumentModule flute;

// 各音の高さ
String [] melody = {
  "A5", "D6", "C6", "G5", "A5", "C6", "G5"
};

String [] melody2 = {
  "A4", "D5", "C5", "G4", "A4", "C5", "G4"
};

// 各音の長さ（拍）
float [] duration = {
  0.5f, 0.5f, 2.0f, 0.5f, 0.5f, 0.5f, 2.0f
};

// 各音の開始位置
float [] startTime = {
  0.0f, 0.5f, 1.0f, 3.0f, 3.5f, 4.0f, 4.5f
};

// 各音の音量
float[] amplitudes = {
  0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f
};

void setup(){
  size(400, 400);
  minim = new Minim(this);
  out = minim.getLineOut();
  pixelDensity(1);

  //指揮者用Arduinoとのシリアル通信設定
  //port = new Serial(this, "/dev/cu.usbmodemXXXXX", xxxx);

  // //フルートの音色
  // //倍音の数とそれぞれの音量を0.0-1.0の間で設定
  // float[] fluteHarmonics = {1.0, 0.4, 0.1}; 
  // out.playNote(0.0, 1.0, new InstrumentModule(
  //   "波形", 周波数, 倍音配列, カットオフ周波数, レゾナンス,  
  //   音量, atk, dec, sus, rel                  
  // ));

  //トランペットの音色
  //trumpet[] trumpetHarmonics = {1.0, 0.4, 0.1}; 
  // out.playNote(0.0, 1.0, new InstrumentModule(
  //   "波形", 周波数, 倍音配列, カットオフ周波数, レゾナンス,  
  //   音量, atk, dec, sus, rel                  
  // ));
}
void draw(){
  background(0);
  stroke(255);

  // 左チャンネルと右チャンネルに入っている波形を描画
  for(int i = 0; i < out.bufferSize() - 1; i++)
  {
    line( i, 50 + out.left.get(i)*50, i+1, 50 + out.left.get(i+1)*50 );
    line( i, 150 + out.right.get(i)*50, i+1, 150 + out.right.get(i+1)*50 );
  }
}

void playSong(String pitch) {
  out.pauseNotes();

  for (int i = 0; i < melody.length; i++) {
    InstrumentConfig flute = new InstrumentConfig();

    flute.out = out;
    flute.waves = new String[] { "SINE", "SINE", "SINE", "TRIANGLE", "TRIANGLE" };

    // melody[i] の音階名を周波数に変換して、この音の基音にする
    flute.baseFreq = Frequency.ofPitch(pitch).asHz();

    flute.harmonics = new float[] { 0.7, 0.7, 0.1, 0.05, 0.01 };
    flute.cutoff = 4000.0;
    flute.res = 0.0;
    flute.filterMode = 0;
    flute.fcoRate = 4.0;
    flute.fcoAmount = 500.0;

    // amplitudes[i] を使って、音ごとの強弱を変える
    flute.vol = amplitudes[i];

    flute.atk = 0.05;
    flute.dec = 0.0;
    flute.sus = 0.8;
    flute.rel = 0.2;

    out.playNote(
      0.0,
      0.2,
      new InstrumentModule(flute)
    );
  }

  out.resumeNotes();
}

void playSong2(String pitch2) {
  out.pauseNotes();

  for (int i = 0; i < melody.length; i++) {
    InstrumentConfig flute = new InstrumentConfig();

    flute.out = out;
    flute.waves = new String[] { "SINE", "SINE", "SINE", "TRIANGLE", "TRIANGLE" };

    // melody2[i] の音階名を周波数に変換して、この音の基音にする
    flute.baseFreq = Frequency.ofPitch(pitch2).asHz();

    flute.harmonics = new float[] { 0.7, 0.8, 0.1, 0.05, 0.01 };
    flute.cutoff = 4000.0;
    flute.res = 0.0;
    flute.filterMode = 0;
    flute.fcoRate = 1.0;
    flute.fcoAmount = 500.0;

    // amplitudes[i] を使って、音ごとの強弱を変える
    flute.vol = amplitudes[i];

    flute.atk = 0.05;
    flute.dec = 0.0;
    flute.sus = 0.8;
    flute.rel = 0.2;

    out.playNote(
      0.0,
      0.2,
      new InstrumentModule(flute)
    );
  }

  out.resumeNotes();
}

void keyPressed() {
  switch (key) {
    case 'a':
      playSong("C5");
      //playSong2("C4");
      break;

    case 's':
      playSong("D5");
      //playSong2("D4");
      break;

    case 'd':
      playSong("E5");
      //playSong2("E4");
      break;

    case 'f':
      playSong("F5");
      //playSong2("F4");
      break;

    case 'g':
      playSong("G5");
      //playSong2("G4");
      break;

    case 'h':
      playSong("A5");
      //playSong2("A4");
      break;

    case 'j':
      playSong("B5");
      //playSong2("B4");
      break;

    case 'k':
      playSong("C6");
      //playSong2("C5");
      break;
  }
}


