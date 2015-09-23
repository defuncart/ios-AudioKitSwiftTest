# ios-AudioKitSwiftTest

<p><b>Requirements</b></p><p>Tested on OSX 10.10.5 and Xcode 7 but should work on Xcode 6 too<br>Basic Csound and Swift knowledge<br></p><p><b>Step 1</b></p><p><a href="http://audiokit.io/downloads/">Download</a> or <a href="https://github.com/audiokit/AudioKit">clone</a> either the stable master version or the in-progress development version.</p><p><b>Step 2</b></p><p>In Xcode 7, create a new single view application using Swift as the default language. Copy <b>AudioKit/AudioKit.xcodeproj </b>into your project. </p><p>At this point we need to choose between the static and dynamic libraries. The static library is easier to incorporate within projects, but requires that all projects utilizing it are open source. The dynamic library may be utilized for commercial or closed-source apps, but is only iOS &nbsp;8+ compatible. For this tutorial we will go with the static library. Full instructions for the dynamic library&nbsp;<a href="https://github.com/audiokit/AudioKit/blob/master/INSTALL-iOS.md">here</a>.&nbsp;</p><p>Now go to Build Phases of your project and select <b>AudioKit iOS Static</b>&nbsp;as a target dependency and <b>libAudioKit iOS Static.a</b>&nbsp;as a linked library.</p><figure data-orig-width="759" data-orig-height="373" class="tmblr-full"><img src="https://40.media.tumblr.com/1dd89b3582d063c36a7c6cbb738f4c91/tumblr_inline_nv4gjuhJPB1raxrd9_540.png" alt="image" data-orig-width="759" data-orig-height="373"></figure></p><p>Next go to the build settings for the iOS project and set&nbsp;<b>Other Linker Flags</b>&nbsp;to -ObjC</p><figure data-orig-width="756" data-orig-height="101" class="tmblr-full"><img src="https://40.media.tumblr.com/41597c4451434dead83ac3031c42c03a/tumblr_inline_nv4gu8AT7k1raxrd9_540.png" alt="image" data-orig-width="756" data-orig-height="101"></figure></p><p>and point the&nbsp;<b>User Header Search Paths</b> to&nbsp;the location of the AudioKit directory&nbsp;with the option recursive selected. This can either be the full path (within quotation marks) or a relative path (as below) from the Xcode project to the AudioKit folder.</p><figure data-orig-width="1008" data-orig-height="124" class="tmblr-full"><img src="https://41.media.tumblr.com/0355a467bee4e84e4093cfdb356aa99a/tumblr_inline_nv4h04a9p31raxrd9_540.png" alt="image" data-orig-width="1008" data-orig-height="124"></figure></p><p>Finally, because the AudioKit library is wrapped in Objective-C and we wish to write our app using Swift, we need to import <b>AudioKit/Platforms/Swift/AudioKit.swift</b> to our project and create a bridge header so that we can access these Objective-C classes in Swift. </p><p>Create a header file named <b>Bridging-Header.h</b><sup>1</sup></p><pre><code>#import "AKFoundation.h"<br></code></pre><p>and go to the build settings of your project and make sure the <b>Objective-C Bridging Header</b> build setting under <b>Swift Compiler - Code Generation</b> has a path to the header.</p><figure data-orig-width="753" data-orig-height="124" class="tmblr-full"><img src="https://41.media.tumblr.com/659fae37e917057d18afc0ccf3529ca7/tumblr_inline_nv4hcf6FQU1raxrd9_540.png" alt="image" data-orig-width="753" data-orig-height="124"></figure></p><p><b>Step 3</b></p><p>Next thing we want to do is to create our user interface. This consists of a <b>UISwitch</b> to turn the sine wave on and off, and a <b>UISlider</b> to spatialize from left to right. By default, this UISlider returns a float value from 0.0 to 1.0, while UISwitch returns a true/false value.</p><figure data-orig-width="387" data-orig-height="697" class="tmblr-full"><img src="https://36.media.tumblr.com/33b615ffdb94d8f0e778f238867b712b/tumblr_inline_nv4i6vxr4x1raxrd9_540.png" alt="image" data-orig-width="387" data-orig-height="697"></figure></p><p><b>Step 4</b></p><p>Now we need to use the AudioKit engine inside our app and connect the UI events to this engine. In ViewController we define a <b>AKInstrument</b> and a <b>AKInstrumentProperty</b> which will serve as our amplitude. This amplitude property is added to the instrument. Next we create a <b>AKOscillator</b> which is a sine wave at 440Hz and has an amplitude governed by the amplitude instrument property. Finally we add the instrument to our orchestra.</p><pre><code>class ViewController: UIViewController
{
  let instrument = AKInstrument()
  let amplitude = AKInstrumentProperty(value: 0.25, minimum: 0.0, maximum: 1.0)
    
  override func viewDidLoad()
  {
    super.viewDidLoad()
     
    instrument.addProperty(amplitude)
        
    let oscillator = AKOscillator(waveform: AKTable.standardSineWave(), frequency: akp(440), amplitude: amplitude)
    instrument.setAudioOutput(oscillator)
        
    AKOrchestra.addInstrument(instrument)
  }
}</code></pre><p>Now we can create methods to handle user interaction. Add the following methods to ViewController and link them to the ui objects in storyboard.</p><pre><code>@IBAction func onOffSwitchToggled(sender: UISwitch)
{
  ( sender.on ? instrument.play() : instrument.stop() )
}

@IBAction func crossFadeSliderMoved(sender: UISlider)
{
  amplitude.value = sender.value
}
</code></pre><p><b>Step 5</b></p><p>Now lets run the application and see it in all it’s glory! (if you want to run the application on your own device, you need an Apple developers account).<br></p>
<p><b>Footnotes</b></p><p><sup>1</sup>Although the Apple Docs state that the Bridging header should be named&nbsp;<b>[MyProjectName]-Bridging-Header.h</b>, as this Bridging header is constant between projects using AudioKit, and because we need to set the header location manually anyway, it makes sense to simply name it&nbsp;<b>Bridging-Header.h</b> and reuse it between projects.</p>
