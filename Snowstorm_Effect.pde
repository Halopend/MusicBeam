/*
 * Copyright (c) 2012 Zepp Lab UG (haftungsbeschränkt) <www.zepplab.net>, Johannes Hoppe <info@johanneshoppe.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

class Snowstorm_Effect extends Effect
{ 

  Snowstorm_Effect(MusicBeam controller, int y)
  {
    super(controller, Effect.defaultWidth, 180, y);

    radiusSlider = cp5.addSlider("radius"+getName()).moveTo(win).setPosition(10, 10).setSize(180, 50);
    radiusSlider.getCaptionLabel().set("Size").align(ControlP5.CENTER, ControlP5.CENTER);
    radiusSlider.setRange(50, 200).setValue(80);

    speedSlider = cp5.addSlider("speed"+getName()).setRange(1, 10).setValue(3).setPosition(10, 65).setSize(180, 50).moveTo(win);
    speedSlider.getCaptionLabel().set("Speed").align(ControlP5.RIGHT, ControlP5.CENTER);

    hueSlider = cp5.addSlider("hue"+getName()).setRange(0, 360).setSize(70, 50).setPosition(65, 120).moveTo(win);
    hueSlider.getCaptionLabel().set("hue").align(ControlP5.RIGHT, ControlP5.CENTER);
    hueSlider.setValue(0);

    aHueToggle = cp5.addToggle("ahue"+getName()).setPosition(10, 120).setSize(50, 50).moveTo(win);
    aHueToggle.getCaptionLabel().set("A").align(ControlP5.CENTER, ControlP5.CENTER);
    aHueToggle.setState(true);

    bwToggle = ctrl.cp5.addToggle("bw"+getName()).setPosition(140, 120).setSize(50, 50).moveTo(win);
    bwToggle.getCaptionLabel().set("BW").align(ControlP5.CENTER, ControlP5.CENTER);
    bwToggle.setState(true);

    calcPoints();
  }

  public String getName()
  {
    return "Snowstorm";
  }

  Slider radiusSlider, speedSlider, hueSlider;

  Toggle aHueToggle, bwToggle;

  LinkedList<Float> r, x, y;

  int px, py, pts;

  int lauf = 0;

  boolean kick = false;

  void draw()
  {
    if (radiusSlider.isMousePressed())
      calcPoints();
    translate(-stg.width/2-lauf*speedSlider.getValue(), -stg.height/2);
    for (int i=0;i<pts;i++) {
      float posx, posy;
      posx = (2*radiusSlider.getValue()*(i%px))+x.get(i);
      posy = (2*radiusSlider.getValue()*(i/px))+y.get(i);
      stg.fill((hueSlider.getValue())%360, bwToggle.getState()?0:100, 100);
      stg.ellipse(posx, posy, r.get(i), r.get(i));
    }

    if (lauf>=(2*radiusSlider.getValue()/speedSlider.getValue())-1) {  
      x.add(x.remove());
      y.add(y.remove());
      r.add(r.remove());
      lauf=0;
    } 
    else
      lauf++;

    if (aHueToggle.getState()&& (isKick()&&isSnare()))
      hueSlider.setValue((hueSlider.getValue()+120)%360);
  }

  void calcPoints() {
    px = int(stg.width/(2*radiusSlider.getValue()))+2;
    py = int(stg.height/(2*radiusSlider.getValue()))+1;
    pts = px*py;
    x = new LinkedList();
    y = new LinkedList();
    r = new LinkedList();
    for (int i=0;i<pts;i++) {
      r.add(i, random(radiusSlider.getValue()/10, radiusSlider.getValue()));
      x.add(i, random(0, radiusSlider.getValue()));
      y.add(i, random(0, radiusSlider.getValue()));
    }
  }
}

