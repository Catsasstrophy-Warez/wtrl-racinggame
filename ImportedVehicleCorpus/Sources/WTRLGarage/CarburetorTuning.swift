import Foundation

public enum AcceleratorPumpCam: String, Codable, CaseIterable, Sendable { case green, pink, orange }
public struct CarburetorCircuitCalibration: Codable, Hashable, Sendable {
    /// Empirical game calibration. These are not universal jet-area or fuel-flow equations.
    public var referencePrimaryJet = 72
    public var referenceSecondaryJet = 84
    public var referenceCruiseAFR = 14.2
    public var referenceWOTAFR = 12.8
    public var afrChangePerPrimaryJetNumber = -0.055
    public var afrChangePerSecondaryJetNumberAtWOT = -0.035
    public var powerValveEnrichmentAFR = -0.65
    public var altitudeAFRChangePer1000M = -0.18
    public init() {}
}
public struct CarburetorCircuitSpec: Codable, Hashable, Sendable {
    public var primaryJetSize: Int
    public var secondaryJetSize: Int
    public var powerValveRatingInHg: Double
    public var acceleratorPumpCam: AcceleratorPumpCam
    public init(primaryJetSize:Int=72,secondaryJetSize:Int=84,powerValveRatingInHg:Double=6.5,acceleratorPumpCam:AcceleratorPumpCam = .orange) {
        self.primaryJetSize=primaryJetSize;self.secondaryJetSize=secondaryJetSize;self.powerValveRatingInHg=powerValveRatingInHg;self.acceleratorPumpCam=acceleratorPumpCam
    }
    public func estimatedAFR(engineVacuumInHg:Double,wideOpenThrottle:Bool,altitudeM:Double=0,calibration c:CarburetorCircuitCalibration = .init())->Double {
        var afr = wideOpenThrottle ? c.referenceWOTAFR : c.referenceCruiseAFR
        afr += Double(primaryJetSize-c.referencePrimaryJet)*c.afrChangePerPrimaryJetNumber
        if wideOpenThrottle {
            afr += Double(secondaryJetSize-c.referenceSecondaryJet)*c.afrChangePerSecondaryJetNumberAtWOT
            if engineVacuumInHg < powerValveRatingInHg { afr += c.powerValveEnrichmentAFR }
        }
        afr += max(0,altitudeM)/1000*c.altitudeAFRChangePer1000M
        return max(9.0,min(18.0,afr))
    }
}
public enum CarburetorDiagnostic {
    public static func recommendation(measuredAFR:Double,targetAFR:ClosedRange<Double>)->String {
        if measuredAFR < targetAFR.lowerBound { return "Mixture is richer than target. Verify fuel pressure, float level and enrichment operation before reducing jet area." }
        if measuredAFR > targetAFR.upperBound { return "Mixture is leaner than target. Verify fuel delivery, vacuum leaks and fuel level before increasing jet area." }
        return "Measured mixture is inside the current calibration target."
    }
}
