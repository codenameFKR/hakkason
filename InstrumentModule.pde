//楽器モジュール（クラス）の設計図
class InstrumentModule implements Instrument {

  Summer _summer; //複合音を作るための変数
  Oscil[] _waves;
  MoogFilter _filter; //フィルター
  float _vol;  // 音量

  //ADSR
  ADSR _adsr;
  float _atk; //音の立ち上がり
  float _dec; //AtackからSustainまでの減衰
  float _sus; //Atackで到達した最大音量からDecayを経て最終的に到達する音量
  float _rel; //余韻

// コンストラクタ:波形の種類，基音，倍音，カットオフ周波数，レゾナンス(CUTOFFの周波数付近を強調する度合い),ADSR
  InstrumentModule(String wave, float baseFreq, float[] harmonics, float cutoff, float res, float vol, float atk, float dec, float sus, float rel) {
    _vol = vol;
    _atk = atk;
    _dec = dec;
    _sus = sus;
    _rel = rel;

    _summer = new Summer();
    _waves = new Oscil[harmonics.length];
    
    // 配列の数だけ波形を作り、周波数と音量を計算してミキサーに繋ぐ
    for (int i = 0; i < harmonics.length; i++) {
      float freq = baseFreq * (i + 1);      // 倍音の周波数 (1倍, 2倍, 3倍...)
      float amp = vol * harmonics[i];       // 倍音の音量 (基本音量 × 渡された比率)
      
      if (wave.equals("SINE")) {
        _waves[i] = new Oscil(freq, amp, Waves.SINE);
      } else if (wave.equals("SAW")) {
        _waves[i] = new Oscil(freq, amp, Waves.SAW);
      } else if (wave.equals("SQUARE")) {
        _waves[i] = new Oscil(freq, amp, Waves.SQUARE);
      } else if (wave.equals("TRIANGLE")) {
        _waves[i] = new Oscil(freq, amp, Waves.TRIANGLE);
      }
      
    
      // 作った波形をミキサー(Summer)に接続
      _waves[i].patch(_summer);
    }

    // 4. フィルターの準備 (カットオフ周波数, レゾナンス, ローパスフィルター)
    _filter = new MoogFilter(cutoff, res, MoogFilter.Type.LP);
    
    // ② 受け取ったADSRの数値を、内部の金庫に記憶しておく
    _adsr = new ADSR(vol, atk, dec, sus, rel);

    // ★ 6. 音の通り道（パッチ）を直列に繋ぐ！
    // 複数の波形(Summer) -> フィルター(MoogFilter) -> 音量制御(ADSR) -> 出力(out)
    _summer.patch(_filter).patch(_adsr).patch(out);
  }

  void noteOn(float duration) {
    _adsr.noteOn();
  }
  
  void noteOff() { 
    _adsr.noteOff();
    _adsr.unpatchAfterRelease(out);
  }
}



