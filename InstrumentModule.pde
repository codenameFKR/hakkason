// 楽器モジュール（クラス）の設計図
class InstrumentModule implements Instrument {

  Summer _summer;
  Oscil[] _waves;
  Oscil _fco;
  MoogFilter _filter;
  ADSR _adsr;

  float _vol;
  float _atk;
  float _dec;
  float _sus;
  float _rel;

  // // 以前の書き方も使えるようにする：波形1つ、フィルターはローパス
  // InstrumentModule(String wave, float baseFreq, float[] harmonics, float cutoff, float res, float vol, float atk, float dec, float sus, float rel) {
  //   this(new String[] { wave }, baseFreq, harmonics, cutoff, res, 0, vol, atk, dec, sus, rel);
  // }

  // // 波形1つ、フィルター種類を指定する版
  // InstrumentModule(String wave, float baseFreq, float[] harmonics, float cutoff, float res, int filterMode, float vol, float atk, float dec, float sus, float rel) {
  //   this(new String[] { wave }, baseFreq, harmonics, cutoff, res, filterMode, vol, atk, dec, sus, rel);
  // }

  // 波形を複数組み合わせる版
  InstrumentModule(String[] waves, float baseFreq, float[] harmonics, float cutoff, float res, int filterMode, float fcoRate, float fcoAmount,float vol, float atk, float dec, float sus, float rel) {
    _vol = vol;
    _atk = atk;
    _dec = dec;
    _sus = sus;
    _rel = rel;

    if (waves == null || waves.length == 0) {
      waves = new String[] { "SINE" };
    }

    if (harmonics == null || harmonics.length == 0) {
      harmonics = new float[] { 1.0 };
    }

    _summer = new Summer();

    int waveTotal = waves.length * harmonics.length;
    _waves = new Oscil[waveTotal];

    int index = 0;

    for (int w = 0; w < waves.length; w++) {
      Waveform waveform = getWaveform(waves[w]);

      for (int i = 0; i < harmonics.length; i++) {
        float freq = baseFreq * (i + 1);

        // 複数波形を足すと音量が大きくなりすぎるので、波形数で割る
        float amp = vol * harmonics[i] / waves.length;

        _waves[index] = new Oscil(freq, amp, waveform);
        _waves[index].patch(_summer);

        index++;
      }
    }

    _filter = new MoogFilter(cutoff, res, getFilterType(filterMode));

    if (fcoRate > 0 && fcoAmount > 0) {
      _fco = new Oscil(fcoRate, fcoAmount, Waves.SINE);
      _fco.offset.setLastValue(cutoff);
      _fco.patch(_filter.frequency);
    }

    _adsr = new ADSR(vol, atk, dec, sus, rel);

    _summer.patch(_filter).patch(_adsr).patch(out);
  }

  Waveform getWaveform(String wave) {
    if (wave == null) {
      return Waves.SINE;
    }

    wave = wave.toUpperCase();

    if (wave.equals("SINE")) {
      return Waves.SINE;
    } else if (wave.equals("SAW")) {
      return Waves.SAW;
    } else if (wave.equals("SQUARE")) {
      return Waves.SQUARE;
    } else if (wave.equals("TRIANGLE")) {
      return Waves.TRIANGLE;
    }

    return Waves.SINE;
  }

  MoogFilter.Type getFilterType(int filterMode) {
    if (filterMode == 0) {
      return MoogFilter.Type.LP;
    } else if (filterMode == 1) {
      return MoogFilter.Type.HP;
    } else if (filterMode == 2) {
      return MoogFilter.Type.BP;
    }

    return MoogFilter.Type.LP;
  }

  void noteOn(float duration) {
    _adsr.noteOn();
  }

  void noteOff() {
    _adsr.noteOff();
    _adsr.unpatchAfterRelease(out);
  }
}
