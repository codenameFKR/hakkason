import ddf.minim.*;
import ddf.minim.ugens.*;
import processing.serial.*;

Minim minim;
AudioOutput out;
InstrumentModule flute;

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

void keyPressed() {
  switch (key)
  {
    case 'p':
      //フルートの音色
      //倍音の数とそれぞれの音量を0.0-1.0の間で設定
      float[] fluteHarmonics = {0.8, 1.0, 0.6, 0.4, 0.2}; 

      flute = new InstrumentModule(
        "SINE", 941.0, fluteHarmonics, 6000.0, 0.0,  
        1.0, 0.2, 0.5, 0.3, 0.3                 
      );

      out.playNote(0.0, 1.0, flute);
      break;
  }
}

