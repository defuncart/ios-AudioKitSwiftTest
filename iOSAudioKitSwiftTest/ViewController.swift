//
//  ViewController.swift
//  iOSAudioKitSwiftTest
//
//  Created by DefuncApps on 9/23/15.
//  Copyright © 2015 DeFunc Art. All rights reserved.
//

import UIKit

class ViewController: UIViewController
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

    // MARK: UI
    
    @IBAction func onOffSwitchToggled(sender: UISwitch)
    {
        ( sender.on ? instrument.play() : instrument.stop() )
    }
    
    @IBAction func crossFadeSliderMoved(sender: UISlider)
    {
        amplitude.value = sender.value
    }
}
