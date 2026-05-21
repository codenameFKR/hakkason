# InstrumentModule マニュアル

`InstrumentModule` は、Processing + Minim で音色を作るための楽器モジュールです。

複数の波形、倍音、フィルター、FCO、ADSR を組み合わせて、シンセサイザーのように音を作ることができます。

このマニュアルは、`InstrumentModule` を使って実際に音を作る人向けです。

---

## できること

`InstrumentModule` では、以下の要素を組み合わせて音色を作れます。

- 複数の波形を重ねる
- 倍音の量を調整する
- フィルターをかける
- FCOでフィルターのカットオフ周波数を揺らす
- ADSRで音の立ち上がりや余韻を調整する

---

## 基本的な使い方

`out.playNote()` の中で `new InstrumentModule(...)` を作って使います。

```java
out.playNote(0.0, 1.0, new InstrumentModule(
  waves,
  baseFreq,
  harmonics,
  cutoff,
  res,
  filterMode,
  fcoRate,
  fcoAmount,
  vol,
  atk,
  dec,
  sus,
  rel
));
```

---

## 引数の順番

`InstrumentModule` には、以下の順番で引数を渡します。

```java
InstrumentModule(
  String[] waves,
  float baseFreq,
  float[] harmonics,
  float cutoff,
  float res,
  int filterMode,
  float fcoRate,
  float fcoAmount,
  float vol,
  float atk,
  float dec,
  float sus,
  float rel
)
```

---

## 引数一覧

| 引数 | 型 | 意味 |
|---|---|---|
| `waves` | `String[]` | 使用する波形("SINE","TRIANGLE","SQUARE","SAW")|
| `baseFreq` | `float` | 基音の周波数 |
| `harmonics` | `float[]` | 倍音の音量バランス |
| `cutoff` | `float` | フィルターのカットオフ周波数 |
| `res` | `float` | レゾナンス |
| `filterMode` | `int` | フィルターの種類 |
| `fcoRate` | `float` | FCOの揺れる速さ |
| `fcoAmount` | `float` | FCOの揺れ幅 |
| `vol` | `float` | 全体の音量 |
| `atk` | `float` | 発音から最大音量になるまでの時間(0.0~1.0) |
| `dec` | `float` | 最大音量からSustain音量まで下がる時間(0.0~1.0) |
| `sus` | `float` | 最終的に保持される音量(0.0~1.0) |
| `rel` | `float` | 発音終了から音が完全に消えるまでの時間(0.0~1.0) |

---

## waves：波形

`waves` では、使いたい波形を配列で指定します。

```java
String[] waves = { "SINE", "TRIANGLE" };
```

使用できる波形は以下です。

| 指定する文字 | 音の特徴 |
|---|---|
| `"SINE"` | なめらかで丸い音 |
| `"TRIANGLE"` | 柔らかく、少し芯のある音 |
| `"SQUARE"` | 電子的で太い音 |
| `"SAW"` | 明るく鋭い音 |

複数指定すると、それらの波形が重なった音になります。

```java
String[] waves = { "SINE", "SAW", "TRIANGLE" };
```

---

## baseFreq：基音の周波数

`baseFreq` は、音の高さを決める基本周波数です。

```java
float baseFreq = 440.0;
```

よく使う周波数の例です。

| 音名 | 周波数 |
|---|---|
| C4 | `261.63` |
| D4 | `293.66` |
| E4 | `329.63` |
| F4 | `349.23` |
| G4 | `392.00` |
| A4 | `440.00` |
| B4 | `493.88` |
| C5 | `523.25` |

---

## harmonics：倍音

`harmonics` は、基音に対してどの倍音をどれくらい鳴らすかを決めます。

```java
float[] harmonics = { 1.0, 0.4, 0.2 };
```

この場合、以下のような意味になります。

| 配列の位置 | 倍音 | 音量 |
|---|---|---|
| `0` | 1倍音 | `1.0` |
| `1` | 2倍音 | `0.4` |
| `2` | 3倍音 | `0.2` |

倍音を増やすと、音は複雑で明るくなります。

倍音を減らすと、音はシンプルで丸くなります。

---

## cutoff：カットオフ周波数

`cutoff` は、フィルターで音を削る基準になる周波数です。

```java
float cutoff = 6000.0;
```

値を小さくすると、こもった音になりやすいです。

値を大きくすると、明るい音になりやすいです。

---

## res：レゾナンス

`res` は、カットオフ周波数付近を強調する量です。

```java
float res = 0.3;
```

値を大きくすると、フィルターのクセが強くなります。

最初は `0.0` から `1.0` くらいで調整すると扱いやすいです。

---

## filterMode：フィルターの種類

`filterMode` は、数字でフィルターの種類を指定します。

| 値 | 種類 | 説明 |
|---|---|---|
| `0` | ローパスフィルター | 高い音を削り、丸い音にする |
| `1` | ハイパスフィルター | 低い音を削り、軽い音にする |
| `2` | バンドパスフィルター | 一部の帯域だけを通す |

例：

```java
int filterMode = 0;
```

---

## fcoRate：FCOの速さ

FCOは、フィルターのカットオフ周波数を自動で揺らす機能です。

`fcoRate` は、その揺れの速さを指定します。

```java
float fcoRate = 4.0;
```

値を大きくすると、フィルターの動きが速くなります。

FCOを使わない場合は `0.0` にします。

```java
float fcoRate = 0.0;
```

---

## fcoAmount：FCOの揺れ幅

`fcoAmount` は、カットオフ周波数をどれくらい大きく揺らすかを指定します。

```java
float fcoAmount = 2000.0;
```

例えば、

```java
cutoff = 6000.0;
fcoAmount = 2000.0;
```

の場合、カットオフ周波数はおおよそ以下の範囲で揺れます。

```text
4000Hz から 8000Hz
```

FCOを使わない場合は `0.0` にします。

```java
float fcoAmount = 0.0;
```

---

## vol：音量

`vol` は、音全体の大きさです。

```java
float vol = 0.7;
```

複数の波形や倍音を重ねると音が大きくなりやすいです。

音が割れる場合は、`vol` を小さくしてください。

```java
float vol = 0.3;
```

---

## ADSRについて

ADSRは、音量の時間変化を作るための設定です。

```text
Attack  →  Decay  →  Sustain  →  Release
```

---

## atk：Attack

`atk` は、発音してから最大音量になるまでの時間です。

```java
float atk = 0.05;
```

値が小さいと、すぐに音が鳴ります。

値が大きいと、ゆっくり音が立ち上がります。

---

## dec：Decay

`dec` は、最大音量からSustain音量まで下がる時間です。

```java
float dec = 0.3;
```

---

## sus：Sustain

`sus` は、音を鳴らしている間に保たれる音量です。

```java
float sus = 0.5;
```

`vol` に対する割合として考えるとわかりやすいです。

---

## rel：Release

`rel` は、音が終わったあと、完全に消えるまでの時間です。

```java
float rel = 0.8;
```

値が小さいと、音はすぐに消えます。

値が大きいと、余韻が長く残ります。

---

# 音色の作例

## 柔らかいフルート風

```java
String[] waves = { "SINE", "TRIANGLE" };
float[] harmonics = { 1.0, 0.4, 0.2 };

out.playNote(0.0, 1.0, new InstrumentModule(
  waves,
  440.0,
  harmonics,
  6000.0,
  0.1,
  0,
  0.0,
  0.0,
  0.7,
  0.2,
  0.4,
  0.5,
  0.8
));
```

---

## 明るいシンセリード風

```java
String[] waves = { "SAW", "SQUARE" };
float[] harmonics = { 1.0, 0.7, 0.4, 0.2 };

out.playNote(0.0, 1.0, new InstrumentModule(
  waves,
  440.0,
  harmonics,
  5000.0,
  0.4,
  0,
  3.0,
  1500.0,
  0.6,
  0.02,
  0.2,
  0.4,
  0.3
));
```

---

## こもったベース風

```java
String[] waves = { "SQUARE", "SAW" };
float[] harmonics = { 1.0, 0.5, 0.2 };

out.playNote(0.0, 1.0, new InstrumentModule(
  waves,
  110.0,
  harmonics,
  1200.0,
  0.6,
  0,
  0.0,
  0.0,
  0.8,
  0.01,
  0.2,
  0.5,
  0.2
));
```

---

## 揺れるフィルター音

```java
String[] waves = { "SAW" };
float[] harmonics = { 1.0, 0.6, 0.3 };

out.playNote(0.0, 2.0, new InstrumentModule(
  waves,
  220.0,
  harmonics,
  3000.0,
  0.5,
  0,
  5.0,
  1500.0,
  0.6,
  0.05,
  0.3,
  0.4,
  1.0
));
```

---

## 軽いハイパス音

```java
String[] waves = { "TRIANGLE", "SQUARE" };
float[] harmonics = { 1.0, 0.3, 0.1 };

out.playNote(0.0, 1.0, new InstrumentModule(
  waves,
  330.0,
  harmonics,
  2000.0,
  0.3,
  1,
  0.0,
  0.0,
  0.5,
  0.03,
  0.2,
  0.4,
  0.4
));
```

---

# 音作りのコツ

## 丸い音にしたいとき

以下のように設定すると、丸く柔らかい音になりやすいです。

- `"SINE"` や `"TRIANGLE"` を使う
- 倍音を少なめにする
- `cutoff` を低めにする
- `filterMode` を `0` にする

例：

```java
String[] waves = { "SINE", "TRIANGLE" };
float[] harmonics = { 1.0, 0.3 };
```

---

## 明るい音にしたいとき

以下のように設定すると、明るい音になりやすいです。

- `"SAW"` を使う
- 倍音を多めにする
- `cutoff` を高めにする

例：

```java
String[] waves = { "SAW" };
float[] harmonics = { 1.0, 0.7, 0.5, 0.3 };
```

---

## 電子的な音にしたいとき

以下のように設定すると、シンセらしい音になりやすいです。

- `"SQUARE"` や `"SAW"` を使う
- `res` を少し上げる
- FCOを使う

例：

```java
String[] waves = { "SQUARE", "SAW" };
float fcoRate = 4.0;
float fcoAmount = 1200.0;
```

---

## 余韻を長くしたいとき

`rel` を大きくします。

```java
float rel = 1.5;
```

---

## 音の立ち上がりをゆっくりにしたいとき

`atk` を大きくします。

```java
float atk = 1.0;
```

---

## 音が割れるとき

`vol` を下げてください。

```java
float vol = 0.4;
```

また、波形や倍音をたくさん重ねると音量が大きくなりやすいです。

その場合は、`harmonics` の値も少し小さくしてください。

```java
float[] harmonics = { 0.7, 0.3, 0.1 };
```

---

# 使用時の注意

## outについて

`InstrumentModule` は、最終的に `out` に音を接続して鳴らします。

そのため、メインプログラム側で `AudioOutput out;` を準備しておく必要があります。

```java
Minim minim;
AudioOutput out;

void setup() {
  minim = new Minim(this);
  out = minim.getLineOut();
}
```

注意点として、`InstrumentModule` クラスの中で `AudioOutput out;` を宣言している場合、その `out` に値が入っていないと音が出ません。

メイン側の `out` をそのまま使う設計にする場合は、クラス内の以下の行は書かないほうが安全です。

```java
AudioOutput out;
```

---

## 最小構成の例

```java
import ddf.minim.*;
import ddf.minim.ugens.*;

Minim minim;
AudioOutput out;

void setup() {
  size(400, 400);

  minim = new Minim(this);
  out = minim.getLineOut();
}

void draw() {
  background(0);
}

void keyPressed() {
  if (key == 'p') {
    String[] waves = { "SINE", "TRIANGLE" };
    float[] harmonics = { 1.0, 0.4, 0.2 };

    out.playNote(0.0, 1.0, new InstrumentModule(
      waves,
      440.0,
      harmonics,
      6000.0,
      0.1,
      0,
      0.0,
      0.0,
      0.7,
      0.2,
      0.4,
      0.5,
      0.8
    ));
  }
}
```

---

# パラメータ調整の目安

| 作りたい音 | waves | harmonics | cutoff | filterMode | atk | rel |
|---|---|---|---|---|---|---|
| フルート風 | `"SINE"`, `"TRIANGLE"` | 少なめ | 高め | `0` | 少し長め | 長め |
| ベース風 | `"SQUARE"`, `"SAW"` | 少なめ | 低め | `0` | 短め | 短め |
| シンセリード風 | `"SAW"`, `"SQUARE"` | 多め | 高め | `0` | 短め | 短め |
| 柔らかいパッド風 | `"SINE"`, `"TRIANGLE"` | 中くらい | 中くらい | `0` | 長め | 長め |
| 軽い音 | `"TRIANGLE"` | 少なめ | 中くらい | `1` | 短め | 中くらい |

---

# まとめ

`InstrumentModule` では、以下の流れで音が作られます。

```text
複数のOscil
    ↓
Summer
    ↓
MoogFilter
    ↓
ADSR
    ↓
out
```

音色を大きく変えたいときは、まず以下の値を調整するとわかりやすいです。

- `waves`
- `harmonics`
- `cutoff`
- `filterMode`
- `fcoRate`
- `fcoAmount`
- `atk`
- `rel`

最初は小さめの音量で試し、音が割れないように調整してください。
