import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.serial.*;

AudioOutput out;
Minim minim;
InstrumentModule flute;

// 各音の高さ
String [] melody = {
  "C5", "C5", "G5", "G5", "A5", "A5", "G5","F5", "F5", "E5", "E5", "D5", "D5", "C5"
};

// 各音の長さ（拍）
float [] duration = {
  0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 1.0f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 1.0f
};

// 各音の開始位置
float [] startTime = {
  0.0f, 0.5f, 1.0f, 1.5f, 2.0f, 2.5f, 3.0f, 4.0f, 4.5f, 5.0f, 5.5f, 6.0f, 6.5f, 7.0f
};

// 各音の音量
float[] amplitudes = {
  0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f, 0.5f
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

void playSong() {
  out.pauseNotes();

  for (int i = 0; i < melody.length; i++) {
    InstrumentConfig flute = new InstrumentConfig();

    flute.out = out;
    flute.waves = new String[] { "SINE", "SINE", "SINE", "SINE", "SAW" };

    // melody[i] の音階名を周波数に変換して、この音の基音にする
    flute.baseFreq = Frequency.ofPitch(melody[i]).asHz();
    // flute.baseFreq = Frequency.ofPitch(pitch).asHz();

    flute.harmonics = new float[] { 0.8, 0.1, 0.1, 0.05, 0.01 };
    flute.cutoff = 1300.0;
    flute.res = 0.0;
    flute.filterMode = 0;
    flute.fcoRate = 0.0;
    flute.fcoAmount = 0.0;

    // amplitudes[i] を使って、音ごとの強弱を変える
    flute.vol = amplitudes[i];

    flute.atk = 0.03;
    flute.dec = 0.0;
    flute.sus = 0.7;
    flute.rel = 0.3;

    out.playNote(
      startTime[i],
      duration[i],
      new InstrumentModule(flute)
    );
  }

  out.resumeNotes();
}

void keyPressed() {
  switch (key) {
    case 'a':
      playSong();
      break;

    // case 's':
    //   playSong("D5");
    //   break;

    // case 'd':
    //   playSong("E5");
    //   break;

    // case 'f':
    //   playSong("F5");
    //   break;

    // case 'g':
    //   playSong("G5");
    //   break;

    // case 'h':
    //   playSong("A5");
    //   break;

    // case 'j':
    //   playSong("B5");
    //   break;

    // case 'k':
    //   playSong("C6");
    //   break;
  }
}


