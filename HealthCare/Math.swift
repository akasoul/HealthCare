import Foundation
import SwiftUI




struct fsNode: Codable, Hashable{
    var dblA: Double = 0
    var dblB: Double = 0
    var dblC: Double = 0
    var dblD: Double = 0
    var dblH: Double = 0
    var dblAvgRR: Double = 0
    var dblIVR: Double = 0
    var dblVPR: Double = 0
    var dblPAPR: Double = 0
    var dblIN: Double = 0
    var dblAge: Double = 0
    var dblBioAge: Double = 0
    var dblRRMin: Double = 0
    var dblRRMax: Double = 0
    var dblRRAll: Double = 0
    var dblRRValid: Double = 0
    var dblRRF1: Double = 0
    var dblRRVitta: Double = 0
    var dblReliability: Double = 0
    
}
struct acmdNode: Codable{
    var fAura: Double = 0
    var fChakra1Sahasrara: Double = 0
    var fChakra2Ajna: Double = 0
    var fChakra3Visuddha: Double = 0
    var fChakra4Anahata: Double = 0
    var fChakra5Manipura: Double = 0
    var fChakra6Svadhisthana: Double = 0
    var fChakra7Muladhara: Double = 0
    var fMeridian01P: Double = 0
    var fMeridian02GI: Double = 0
    var fMeridian03E: Double = 0
    var fMeridian04RP: Double = 0
    var fMeridian05C: Double = 0
    var fMeridian06IG: Double = 0
    var fMeridian07V: Double = 0
    var fMeridian08R: Double = 0
    var fMeridian09MC: Double = 0
    var fMeridian10TR: Double = 0
    var fMeridian11VB: Double = 0
    var fMeridian12F: Double = 0
}
struct strokeNode: Hashable{
    var arrA: [Double]=[]
    var arrB: [Double]=[]
    var arrC: [Double]=[]
    var arrD: [Double]=[]
    var arrH: [Double]=[]
}


struct RR: Codable,Hashable{
    var rrValue: Int = 0
    enum rrMask: Int, Codable{
        case good
        case bad
        case vitta
    }
    var mask: rrMask = .good
}



let g_CoeffA: [Double] =
    [ 15.5,16.804,17.74,18.178,19.518,20.102,20.905,21.48,22.066,22.825,23.984,24.888,25.328,26.028,26.922,27.466,28.581,29.043,29.441,29.952,30.781,
      31.816,32.353,32.614,33.134,33.379,34.318,36.19,36.732,37.247,37.813,38.696,39.031,39.834,40.701,41.447,42.388,42.978,43.715,44.872,45.851,
      47.128,47.739,49.621,50.797,51.798,52.555,53.307,53.875,54.754,55.665,56.613,57.455,58.544,59.259,60.45,62.882,64.11,64.951,66.075,68.426,70.208,
      71.674,73.269,75.414,76.986,78.1,81.087,82.572,85.607,86.91,87.859,88.635,89.758,90.639,92.01,93.071,94.046,96.169,97.855,99.674,102.899,105.431,
      106.601,109.454,110.796,114.095,115.421,119.213,120.709,124.114,125.51,128.079,130.446,132.449,136.862,140.572,144.339,149.332,156.886,170.0 ]

//B
let g_CoeffB: [Double] =
    [ 1.7,2.108,2.34,2.462,2.68,2.851,3.003,3.227,3.533,3.719,3.907,4.022,4.23,4.361,4.584,4.746,4.921,5.158,5.307,5.427,5.821,6.05,6.192,6.346,
      6.476,6.741,6.907,7.11,7.361,7.488,7.697,8.029,8.307,8.561,8.884,9.053,9.307,9.412,9.779,9.938,10.108,10.801,11.404,11.745,12.154,12.223,
      12.293,12.686,12.877,13.144,13.408,13.781,14.052,14.303,14.793,14.917,15.081,15.503,16.352,16.884,17.293,17.606,18.524,18.708,18.946,19.321,
      19.713,20.098,20.417,21.004,21.411,22.443,23.073,23.738,24.234,24.5,24.985,25.167,25.993,26.505,27.716,28.181,29.24,29.622,30.48,31.111,31.411,
      32.169,32.777,33.62,35.13,36.456,37.857,39.132,40.099,42.897,45.783,53.672,56.428,63.734,70.0 ]

//C
let g_CoeffC: [Double] =
    [ 0.25,0.382,0.535,0.711,0.915,1.307,1.74,2.734,4.377,5.332,8.551,12.505,13.523,18.557,24.253,32.746,38.575,43.979,58.988,66.38,69.132,78.409,
      96.778,103.947,125.45,153.34,174.582,203.424,262.595,293.455,339.714,361.524,419.304,442.836,536.901,609.771,693.567,769.823,901.672,1.01E+03,
      1.16E+03,1.27E+03,1.47E+03,1.61E+03,1.78E+03,2.08E+03,2.56E+03,2.79E+03,3.40E+03,4.02E+03,4.54E+03,5.41E+03,5.90E+03,6.61E+03,7.37E+03,9.14E+03,
      9.47E+03,1.08E+04,1.24E+04,1.40E+04,1.77E+04,1.90E+04,2.25E+04,2.53E+04,3.18E+04,3.71E+04,4.00E+04,4.76E+04,6.11E+04,7.42E+04,8.73E+04,1.12E+05,
      1.53E+05,1.68E+05,2.01E+05,2.21E+05,2.50E+05,2.95E+05,3.50E+05,3.77E+05,4.25E+05,5.04E+05,5.82E+05,6.83E+05,7.07E+05,7.87E+05,9.57E+05,1.04E+06,
      1.11E+06,1.19E+06,1.38E+06,1.55E+06,1.97E+06,2.15E+06,2.31E+06,2.53E+06,2.79E+06,3.17E+06,3.80E+06,6.86E+06,1.00E+07 ]

//D
let g_CoeffD: [Double] =
    [ 1.0,1.24,1.368,1.505,1.639,1.823,1.992,2.174,2.391,2.474,2.701,3.312,3.481,3.768,4.157,4.287,4.397,4.583,4.907,5.182,5.352,5.716,5.966,6.47,
      6.584,6.798,7.334,7.711,8.173,8.769,9.035,9.712,10.514,10.899,11.169,11.456,12.132,12.742,13.292,13.659,14.042,14.348,15.001,15.859,16.897,
      17.388,18.188,18.953,19.871,20.35,21.78,22.582,23.266,24.859,25.661,26.683,28.085,29.012,30.055,31.926,33.17,34.975,36.239,39.453,41.288,
      42.869,45.27,47.621,50.104,53.482,56.734,62.394,66.488,70.143,73.17,76.947,80.468,82.31,87.328,88.333,90.854,95.664,98.6,101.377,106.612,
      112.093,115.581,119.535,122.915,129.352,134.583,139.599,143.495,147.188,151.007,159.181,165.953,169.531,194.586,204.759,250.0 ]

//B2
let g_CoeffB2: [Double] =
    [ 2.0,2.065,2.17,2.225,2.302,2.367,2.407,2.465,2.531,2.585,2.636,2.722,2.814,2.936,3.008,3.058,3.124,3.195,3.234,3.275,3.318,3.448,3.53,3.606,
      3.668,3.737,3.783,3.876,3.893,3.923,3.953,4.01,4.079,4.12,4.182,4.225,4.269,4.316,4.382,4.491,4.518,4.553,4.61,4.67,4.757,4.933,4.984,5.013,
      5.08,5.178,5.256,5.33,5.395,5.489,5.639,5.685,5.754,5.846,5.892,6.0,6.038,6.124,6.202,6.285,6.361,6.479,6.549,6.639,6.734,6.811,6.955,7.013,
      7.163,7.281,7.434,7.482,7.591,7.653,7.725,7.805,7.888,7.916,8.011,8.149,8.235,8.288,8.35,8.373,8.559,8.638,8.75,8.84,8.988,9.158,9.321,9.428,
      9.587,9.763,9.956,10.344,11.0 ]

//C'
let g_CoeffCh: [Double] =
    [ 4.0,4.609,5.051,6.012,6.547,7.802,9.078,10.073,10.469,11.269,13.07,14.261,15.356,16.077,17.534,18.42,19.762,20.969,23.009,24.619,25.941,27.657,
      29.728,30.474,31.438,32.745,35.747,37.014,38.437,40.594,42.711,44.411,46.408,47.634,49.022,50.921,53.342,54.379,58.018,61.391,65.166,69.404,
      71.725,74.619,76.211,80.084,87.298,91.29,96.895,100.609,103.27,107.962,115.808,121.448,123.799,130.278,134.145,139.229,144.073,149.847,154.156,
      164.727,175.108,187.054,198.062,209.606,220.19,226.09,243.743,261.804,276.842,287.293,300.91,319.122,331.054,348.881,381.303,399.521,412.439,
      423.074,430.628,443.368,455.341,462.666,483.51,524.551,545.606,562.387,580.024,600.211,641.844,669.954,704.875,740.37,791.056,833.183,906.49,
      948.449,984.606,1.03E+03,1.10E+03 ]

//C2
let g_CoeffC2: [Double] =
    [ 6,7,7.68,8.54,10.36,11.2,13.5,14.5,15.22,16.5,17.5,19,20.66,22,23,23.5,25.88,26.5,28,28,29,30,31.48,32,32.5,34,34.34,36.18,37.52,38.86,40,41,41.88,
      43.22,44.56,46.5,47.5,48.5,49,50.5,52,52.5,54,55.5,56.96,59.4,61.5,62.48,64.32,65.16,66,67,68,69.04,72.36,73.9,75,76.5,78.22,78.56,80.5,82.7,87.08,
      88.92,91.76,95,96,98.34,102.62,105.42,107.6,109.92,114.94,116.32,117.82,119.5,122.84,126.68,129.02,131.36,133.2,137.04,141.38,146,152.56,156.8,161,
      163.24,167.42,169.5,173.5,178.26,182.12,186.12,188.88,190.8,194.64,206.36,215.96,223.88,240 ]

//D2
let g_CoeffD2: [Double] =
    [ 5.0,7.993,10.489,12.264,14.646,19.025,26.91,33.37,48.644,60.813,76.771,88.834,96.811,122.253,128.02,138.029,178.153,206.365,218.201,253.16,
      270.505,310.641,345.873,371.005,378.398,443.036,537.815,607.759,659.819,693.501,772.407,843.464,925.838,1.05E+03,1.13E+03,1.27E+03,1.32E+03,
      1.46E+03,1.53E+03,1.58E+03,1.63E+03,1.87E+03,2.17E+03,2.29E+03,2.55E+03,2.66E+03,2.83E+03,3.15E+03,3.46E+03,3.83E+03,4.28E+03,4.66E+03,5.00E+03,
      5.55E+03,6.01E+03,6.89E+03,7.43E+03,8.49E+03,9.46E+03,1.01E+04,1.10E+04,1.27E+04,1.41E+04,1.53E+04,1.68E+04,1.79E+04,2.13E+04,2.45E+04,2.60E+04,
      2.72E+04,3.02E+04,3.74E+04,4.82E+04,5.35E+04,5.90E+04,6.46E+04,7.16E+04,7.85E+04,8.57E+04,8.93E+04,9.65E+04,1.05E+05,1.16E+05,1.30E+05,1.44E+05,
      1.52E+05,1.64E+05,1.69E+05,1.85E+05,2.29E+05,2.44E+05,2.55E+05,2.79E+05,2.98E+05,3.27E+05,3.49E+05,3.66E+05,3.85E+05,3.97E+05,6.97E+05,1.00E+06 ]



class dnaMath{
    var mt_dEcgArray: [Double] = [Double].init(repeating: 0, count: 2000) //2000
    var mt_dECGKorrArray: [Double] = [Double].init(repeating: 0, count: 2000); //2000
    var mt_dwIC: Int
    var mt_nCntECG:Int
    var mt_nTotalCount: Int
    var mt_nCurrentLen: Int
    var mt_nCurL: Int
    var mt_dKSArray: [Double] = [Double].init(repeating: 0, count: 16) //16
    var mt_lEntHere: Bool
    var mt_dMnG: Double
    var mt_dMnG1: Double
    var mt_nLen: Int
    var mt_dPsrRR: Double
    var mt_nPrCurrentLen: Int
    var mt_nMaxLen: Int
    var mt_nMaxPrev: Int
    var mt_nSm: Int
    var mt_nRR: Int
    var mt_nRRt: Int
    var mt_dwPrTochnZnRR: Int
    var mt_dAverageRR:Double
    var mt_AvgRR1: Double
    var mt_nRR57: Int
    var mt_nRRz57: Int
    var mt_nRR57Array: [Int] = [Int].init(repeating: 0, count: 57)//57
    var mt_nRRiCounter: Int
    var mt_dAvgRRs:Double
    var mt_dAvgRRo:Double
    var mt_nLastRRi:Int
    var mt_nPrevRRInt:Int
    var mt_nPrevRR: Int
    
    init(){
        mt_AvgRR1 = 0.0
        mt_nLastRRi = 0
        mt_nTotalCount = 0
        mt_nCurrentLen = 0
        mt_nPrCurrentLen = 0
        mt_nMaxLen = 60
        mt_nMaxPrev = 60
        mt_nLen = 0
        mt_nRR = 0
        mt_nRRz57 = 13
        mt_nRR57 = 0
        
        mt_dAverageRR = 0.0
        mt_nRRt = 0;
        mt_nPrevRR = 0
        
        
        mt_dwIC = 0;
        mt_nCntECG = 2000;
        mt_dwPrTochnZnRR = 0;
        mt_dKSArray[0] = 1489.0
        mt_dKSArray[1] = 1491.0
        mt_dKSArray[2] = 1500.0
        mt_dKSArray[3] = 1500.0
        mt_dKSArray[4] = 1509.0
        mt_dKSArray[5] = 1511.0
        mt_dKSArray[6] = 1600.0
        mt_dKSArray[7] = 10.0
        mt_dKSArray[8] = 20.0
        mt_dKSArray[9] = 0.00001
        mt_dKSArray[10] = 30.0
        mt_dKSArray[11] = 0.0000001;
        mt_dKSArray[12] = 0.1
        mt_dKSArray[13] = 0.1
        mt_dKSArray[14] = 3.0
        mt_dKSArray[15] = 10.0
        
        
        mt_dAvgRRs = 0.0
        
        mt_dPsrRR = 0
        mt_dMnG1 = 1.0
        mt_nCurL = 0
        mt_lEntHere = false
        
        mt_dMnG = 0.0
        mt_nSm = 0
        
        
        // инициализация параметров не вызывалась
        mt_nRRiCounter=0
        mt_dAvgRRo=0
        mt_nPrevRRInt=0
        /////////////////////////////////////////
    }
    
    internal static func MtInnerNormalization(_ dVariable: Double, _ dCoefficientsArray:[Double]/* 101*/)->Double{
        
        if (dVariable <= dCoefficientsArray[0]){
            return 0.0
        }
        if (dVariable >= dCoefficientsArray[100]){
            return 100.0
        }

        for i in 0..<100{
            if ((dVariable>=dCoefficientsArray[i])&&(dVariable<dCoefficientsArray[i+1])){
                let znach: Double = (((dVariable-dCoefficientsArray[i])/(dCoefficientsArray[i+1]-dCoefficientsArray[i]))+Double(i))
                return znach
            }
        }
        return 0.0
        
    }
    
    internal static func MtInnerGetSquareCD(nRR57Array: inout [Int]/*[57]*/, nCount: Int, dSC: inout Double, dSD: inout Double) -> Bool{
        
        if (nCount != 57){
            return false
        }

        var nNewRR57Array: [Int]=[Int].init(repeating: 0, count: 60)
        var nPikNewArray: [Int]=[Int].init(repeating: 0, count: 60)
        var nCh:Int = 0
        
        for j in 0..<nCount-1{
            if (nRR57Array[j+1] != nRR57Array[j]){
                nNewRR57Array[nCh] = nRR57Array[j];
                nCh += 1
            }
        }
        nNewRR57Array[nCh] = nRR57Array[(nCount-1)];

        var dSCh: Int = 1;
        var nNPArray: [Int]=[Int].init(repeating: 0, count: 60)
        nPikNewArray[0] = nNewRR57Array[0]
        nNPArray[0] = 0
        
        for j in 1..<nCh{
            if (((nNewRR57Array[j]-nNewRR57Array[j-1])*(nNewRR57Array[j+1]-nNewRR57Array[j]))<0)
            {
                nPikNewArray[j] = nNewRR57Array[j];
                nNPArray[dSCh] = j;
                dSCh += 1
            }
            else
            {
                nPikNewArray[j] = 0;
            }
        }
        nPikNewArray[nCh] = nNewRR57Array[nCh];
        nNPArray[dSCh] = nCh;

        var nFirst: Int
        var nLast: Int
        var nSChVN: Int
        if (nNewRR57Array[0]>nNewRR57Array[nNPArray[1]]){
            nFirst=1;
        }
        else{
            nFirst=2;
        }
        if (nNewRR57Array[nNPArray[dSCh]]>nNewRR57Array[nNPArray[dSCh-1]]){
            nLast=dSCh-1;
        }
        else{
            nLast=dSCh-2;
        }
        var lFl: Bool = true;
        var nMaxSChV: Int = 0;
        var nMaxSChN: Int = 0;
        var dMV1Array: [Double]=[Double].init(repeating: 0, count: 60)
        var dMN1Array: [Double]=[Double].init(repeating: 0, count: 60)
        var dMVArray : [Double]=[Double].init(repeating: 0, count: 60)
        var dMNArray : [Double]=[Double].init(repeating: 0, count: 60)
        var nMVschArray: [Int]=[Int].init(repeating: 0, count: 60)
        var nMNschArray: [Int]=[Int].init(repeating: 0, count: 60)
     

        for j in nFirst..<nLast{
            nSChVN=0
            if (lFl){
                for i in nNPArray[j]...nNPArray[j+1]{
                    if (nMVschArray[nSChVN]==0){
                        dMV1Array[nSChVN]=0;
                    }
                    dMV1Array[nSChVN] += Double(nNewRR57Array[i])
                    nMVschArray[nSChVN] += 1
                    dMVArray[nSChVN] = dMV1Array[nSChVN]/Double(nMVschArray[nSChVN])
                    nSChVN += 1
                    if (nMaxSChV < nSChVN){
                        nMaxSChV = nSChVN;
                    }
                }
                lFl=false;
            }
            else{
                for i in nNPArray[j]...nNPArray[j+1]{
                    if (nMNschArray[nSChVN]==0){
                        dMN1Array[nSChVN]=0
                    }
                    dMN1Array[nSChVN] += Double(nNewRR57Array[i])
                    nMNschArray[nSChVN] += 1
                    dMNArray[nSChVN] = dMN1Array[nSChVN]/Double(nMNschArray[nSChVN])
                    nSChVN += 1
                    if (nMaxSChN < nSChVN){
                        nMaxSChN = nSChVN;
                    }
                }
                lFl=true;
            }
        }
        var dMVCArray:[Double]=[Double].init(repeating: 0, count: 60)
        var dMNCArray:[Double]=[Double].init(repeating: 0, count: 60)
        var nCntMVC: Int=0
        var nCntMNC: Int=0

        var dMinMVC: Double=0
        var dMinMNC: Double=0
        var dMinMVD: Double=0
        var dMinMND: Double=0
        if (nMaxSChV>0){
            dMinMVD=dMVArray[0];
        }
        if (nMaxSChN>0){
            dMinMND=dMNArray[0];
        }

        for i in 0..<nMaxSChV{
            if (nMVschArray[i]>1){
                if (nCntMVC==0){
                    dMinMVC = dMVArray[0];
                }
                if (dMinMVC>dMVArray[i]){
                    dMinMVC=dMVArray[i];
                }
                dMVCArray[i] = dMVArray[i];
                nCntMVC += 1
            }
            if (dMinMVD>dMVArray[i]){
                dMinMVD=dMVArray[i]
            }
        }

        for i in 0..<nMaxSChN{
            if (nMNschArray[i]>1)
            {
                if (nCntMNC==0)
                {
                    dMinMNC = dMNArray[0];
                }
                if (dMinMNC>dMNArray[i])
                {
                    dMinMNC=dMNArray[i];
                }
                dMNCArray[i] = dMNArray[i];
                nCntMNC += 1
            }
            if (dMinMND>dMNArray[i]){
                dMinMND = dMNArray[i];
            }
        }

        var dFM1: Double = 0.0;
        var dMaxMass: Double = 0.0;
        if (nMaxSChV>0){
            dMVCArray[0] = dMVCArray[0]-dMinMVC;
            dMaxMass = dMVCArray[0];
        }
        for i in 1..<nCntMVC{
            dMVCArray[i] = dMVCArray[i]-dMinMVC;
            if (dMaxMass<dMVCArray[i])
            {
                dMaxMass=dMVCArray[i];
            }
            dFM1 += (dMVCArray[i]+dMVCArray[i-1])/2.0;
        }
        dFM1 *= dMaxMass;

        var dFM2: Double = 0.0;
        if (nMaxSChN>0){
            dMNCArray[0] = dMNCArray[0]-dMinMNC;
            dMaxMass = dMNCArray[0];
        }
        for i in 1..<nCntMNC{
            dMNCArray[i] = dMNCArray[i]-dMinMNC;
            if (dMaxMass<dMNCArray[i]){
                dMaxMass = dMNCArray[i];
            }
            dFM2 += (dMNCArray[i]+dMNCArray[i-1])/2.0;
        }
        dFM2 *= dMaxMass;

        var dFM3: Double=0.0;
        if (nMaxSChV>0){
            dMVArray[0] = dMVArray[0]-dMinMVD;
            dMaxMass = dMVArray[0];
        }
        for i in 1..<nMaxSChV{
            dMVArray[i] = dMVArray[i]-dMinMVD;
            if (dMaxMass<dMVArray[i])
            {
                dMaxMass = dMVArray[i];
            }
            dFM3 += (dMVArray[i]+dMVArray[i-1])/2.0;
        }
        dFM3 *= dMaxMass;

        var dFM4: Double=0.0;
        if (nMaxSChN>0){
            dMNArray[0] = dMNArray[0]-dMinMND;
            dMaxMass = dMNArray[0];
        }
        for i in 1..<nMaxSChN{
            dMNArray[i] = dMNArray[i]-dMinMND;
            if (dMaxMass<dMNArray[i]){
                dMaxMass = dMNArray[i];
            }
            dFM4 += (dMNArray[i]+dMNArray[i-1])/2.0;
        }
        dFM4 *= dMaxMass;

        dSC = dFM1 + dFM2;
        dSD = dFM3 + dFM4;

        return true
        
    }
    
    internal static func MtInnerFilterRR(pRRArray: inout [Int])->Double{
        return 0
    }
    
    internal static func MtInnerPrepareRithmogram(pRRArray: inout [Int], nMeridian: Int, pTSArray: inout [Int]){
        
    }
    
    internal static func MtInnerEnergyRatioInPiramid(pRRArray: inout [Int])->Double{
        return 0
    }
    
    internal static func MtInnerThresholdFilter(pRRArray: inout [Int],  pFilteredArray: inout [Int], nThreshold: Int = 50){
        
    }
    
    
    internal static func MtInnerGetAB(nClearRRArray: inout [Int], nCount: Int,  nStartIndex: Int, dRRsr: inout Double, dMo: inout Double, dAMo: inout Double, dDx: inout Double, dSKO: inout Double, dMb: inout Double){
        
        dRRsr = 0.0;
        
        for i in nStartIndex..<nCount{
            dRRsr += Double(nClearRRArray[i])
        }
        dRRsr = (dRRsr)/Double(nCount-nStartIndex);

        let dStep: Double = 40.0
        let dBase: Double = 320.0
        var nHistoArray: [Int] = [Int].init(repeating: 0, count: 50)
        
        for i in 0..<50{
            nHistoArray[i] = 0
        }
        var nIndex: Int = 0
        dSKO = 0.0
        var dRRmin: Double = Double(nClearRRArray[nStartIndex])
        var dRRmax: Double = Double(nClearRRArray[nStartIndex])

        for i in nStartIndex..<nCount{
            if (dRRmin<Double(nClearRRArray[i])){
                dRRmin = Double(nClearRRArray[i])
            }
            if (dRRmax>Double(nClearRRArray[i])){
                dRRmax = Double(nClearRRArray[i])
            }
            
            dSKO += pow(fabs(Double(nClearRRArray[i])-dRRsr), 2.0)
            nIndex = Int((Double(nClearRRArray[i])-dBase)/dStep)
            if (nIndex<0){
                nIndex=0;
            }
            if (nIndex>49){
                nIndex=49;
            }
            nHistoArray[nIndex] += 1;
        }
        dSKO = sqrt(dSKO/Double(nCount-nStartIndex))
        dDx = fabs(dRRmax-dRRmin)

        nIndex = 0;
        dMo = 0.0;
        
        for i in 0..<50{
            if (dMo<Double(nHistoArray[i]))
            {
                dMo = Double(nHistoArray[i])
                nIndex = i
            }
        }
        dMo = dBase+Double(nIndex)*dStep
        dAMo = (Double(nHistoArray[nIndex]))/(Double(nCount-nStartIndex))
        dMb = (2*dSKO*dMo)/dAMo
    }
    
    internal static func MtGetPiram(nClearRRArray: inout [Int], nCount: Int,
                                    nPyramideArray: inout [Int]/*[26]*/, dC2: inout Double, fDelta: inout Double,
                                    nStartPos: Int=3 )->Bool{
        let nPyramideArraySize=nPyramideArray.count
        if (nPyramideArraySize < 26){
            return false
        }
        
        var lRet: Bool = false

        for i in 0..<26{
            nPyramideArray[i] = 0;
        }
        dC2 = 0.0;
        fDelta = 0.0;

        if ((nCount>3) && (nCount-nStartPos>0)){
            var NewRR: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var PikNew: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var Mass_N_P: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var nMVschArray: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var nMNschArray: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var MVt: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var MNt: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)


            if (nCount-nStartPos <= 0){
                return lRet;
            }
                
            var nDsch: Int = 0
            var nCh: Int = 0
            //MARK:             for j in nStartPos..<nCount-1{

            for j in nStartPos..<nCount-1{
                if (nClearRRArray[j+1] != nClearRRArray[j]){
                    NewRR[nCh] = nClearRRArray[j];
                    nCh += 1
                }
            }
            NewRR[nCh] = nClearRRArray[(nCount-1)];
            var nSCh: Int = 1
            PikNew[0] = NewRR[0]
            Mass_N_P[0] = 0;
            for j in 1..<nCh{
                if (((NewRR[j]-NewRR[j-1])*(NewRR[j+1]-NewRR[j]))<0){
                    PikNew[j] = NewRR[j]
                    Mass_N_P[nSCh] = j
                    nSCh += 1
                }
                else
                {
                    PikNew[j] = 0
                }
            }
            PikNew[nCh] = NewRR[nCh]
            if (((nCount-1)-nStartPos+1)>nSCh){
                Mass_N_P[nSCh] = nCh;
            }
            if (nSCh>4)
            {
                var nFirst: Int;
                var nLast: Int;

                if (NewRR[0]>NewRR[Mass_N_P[1]]){
                    nFirst = 1;
                }
                else{
                    nFirst = 2;
                }
                if (NewRR[Mass_N_P[nSCh]]>NewRR[Mass_N_P[nSCh-1]]){
                    nLast = nSCh-1;
                }
                else{
                    nLast = nSCh-2;
                }
                var lFl: Bool = true

                var nSChV: Int = 0
                var nSChN: Int = 0
                for i in 0..<nCount-nStartPos{
                    nMVschArray[i] = 0;
                    nMNschArray[i] = 0;
                }
                for j in nFirst..<nLast{
                    if (lFl){
                        if ((Mass_N_P[j]+1) != Mass_N_P[j+1]){
                            nMVschArray[nSChV] = Mass_N_P[j+1]-Mass_N_P[j];
                            let Delt: Double = Double(NewRR[Mass_N_P[j+1]]-NewRR[Mass_N_P[j]])
                            fDelta += Delt;
                            nDsch += 1
                            nMVschArray[nSChV] = (round_i1(Delt*Double(nMVschArray[nSChV]) / 100.0));
                            if (nMVschArray[nSChV] != 0){
                                nSChV += 1
                            }
                        }
                        lFl = false
                    }
                    else
                    {
                        if ((Mass_N_P[j]+1) != Mass_N_P[j+1])
                        {
                            nMNschArray[nSChN] = Mass_N_P[j+1]-Mass_N_P[j];
                            let Delt: Double = Double(NewRR[Mass_N_P[j]]-NewRR[Mass_N_P[j+1]])
                            fDelta += Delt
                            nDsch += 1
                            nMNschArray[nSChN] = (round_i1(Delt*Double(nMNschArray[nSChN]) / 100.0));
                            if (nMNschArray[nSChN] != 0){
                                nSChN += 1
                            }
                        }
                        lFl = true
                    }
                }
                var nVN: Int
                var nVnn: Int
                var fSVos: Double = 0.0;
                var fSNis: Double = 0.0;
                if (nSChV>0){
                    for j in 0..<nSChV{
                        MVt[j] = nMVschArray[j];
                        nVN = j;
                        for i in 0..<nSChV{
                            if (nMVschArray[i]<MVt[j]){
                                MVt[j] = nMVschArray[i];
                                nVN = i;
                            }
                        }
                        fSVos += Double(nMVschArray[nVN])
                        nMVschArray[nVN] = 0xffff;
                    }
                    nVnn = MVt[nSChV-1];
                    for k in 0..<nVnn{
                        let zch: Int = labs(k-13+1);
                        for j in 0..<nSChV{
                            if (MVt[j] != 0){
                                if (k<13){
                                    nPyramideArray[zch] += 1
                                }
                            }
                        }
                        for j in 0..<nSChV{
                            if (MVt[j] != 0){
                                MVt[j] += -1
                            }
                        }
                    }
                }
                if (nSChN>0){
                    for j in 0..<nSChN{
                        MNt[j] = nMNschArray[j];
                        nVN = j;
                        for i in 0..<nSChN{
                            if (nMNschArray[i]<MNt[j]){
                                MNt[j] = nMNschArray[i];
                                nVN = i;
                            }
                        }
                        fSNis += Double(nMNschArray[nVN])
                        nMNschArray[nVN] = 0xffff;
                    }
                    let nNnn: Int = MNt[nSChN-1];
                    
                    for k in 0..<nNnn{
                        for j in 0..<nSChN{
                            if (MNt[j] != 0){
                                if (k<13){
                                    nPyramideArray[k+13] += 1
                                }
                            }
                        }
                        for j in 0..<nSChN{
                            if (MNt[j] != 0){
                                MNt[j] += -1
                            }
                        }
                    }
                }
                dC2 = (fSNis+fSVos)/2.0;
                if (nDsch != 0){
                    fDelta = fDelta/Double(nDsch)
                }
                else{
                    fDelta = 0.0;
                }
            }
            dC2 = dnaMath.MtInnerNormalization(dC2, g_CoeffC2)
            lRet = true


        }

        return lRet;
        
    }
    
    internal static func MtGetPiram(nClearRRArray: inout [Int], nCount: Int, nPyramideArray: inout [Int] /* 26*/, nPyramideArraySize: Int,
                                    nStartPos: Int=3) -> Bool{

        let nPyramideArraySize=nPyramideArray.count
        if (nPyramideArraySize < 26){
            return false
        }
        
        var lRet: Bool = false

        for i in 0..<26{
            nPyramideArray[i] = 0;
        }


        if ((nCount>3) && (nCount-nStartPos>0)){
            var NewRR: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var PikNew: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var Mass_N_P: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var nMVschArray: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var nMNschArray: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var MVt: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)
            var MNt: [Int]=[Int].init(repeating: 0, count: nCount-nStartPos)


            if (nCount-nStartPos <= 0){
                return lRet;
            }
                
            var nDsch: Int = 0
            var nCh: Int = 0
            //MARK:             for j in nStartPos..<nCount-1{

            for j in nStartPos..<nCount-1{
                if (nClearRRArray[j+1] != nClearRRArray[j]){
                    NewRR[nCh] = nClearRRArray[j];
                    nCh += 1
                }
            }
            NewRR[nCh] = nClearRRArray[(nCount-1)];
            var nSCh: Int = 1
            PikNew[0] = NewRR[0]
            Mass_N_P[0] = 0;
            for j in 1..<nCh{
                if (((NewRR[j]-NewRR[j-1])*(NewRR[j+1]-NewRR[j]))<0){
                    PikNew[j] = NewRR[j]
                    Mass_N_P[nSCh] = j
                    nSCh += 1
                }
                else
                {
                    PikNew[j] = 0
                }
            }
            PikNew[nCh] = NewRR[nCh]
            if (((nCount-1)-nStartPos+1)>nSCh){
                Mass_N_P[nSCh] = nCh;
            }
            if (nSCh>4)
            {
                var nFirst: Int;
                var nLast: Int;

                if (NewRR[0]>NewRR[Mass_N_P[1]]){
                    nFirst = 1;
                }
                else{
                    nFirst = 2;
                }
                if (NewRR[Mass_N_P[nSCh]]>NewRR[Mass_N_P[nSCh-1]]){
                    nLast = nSCh-1;
                }
                else{
                    nLast = nSCh-2;
                }
                var lFl: Bool = true

                var nSChV: Int = 0
                var nSChN: Int = 0
                for i in 0..<nCount-nStartPos{
                    nMVschArray[i] = 0;
                    nMNschArray[i] = 0;
                }
                for j in nFirst..<nLast{
                    if (lFl){
                        if ((Mass_N_P[j]+1) != Mass_N_P[j+1]){
                            nMVschArray[nSChV] = Mass_N_P[j+1]-Mass_N_P[j];
                            let Delt: Double = Double(NewRR[Mass_N_P[j+1]]-NewRR[Mass_N_P[j]])
                            nDsch += 1
                            nMVschArray[nSChV] = (round_i1(Delt*Double(nMVschArray[nSChV]) / 100.0));
                            if (nMVschArray[nSChV] != 0){
                                nSChV += 1
                            }
                        }
                        lFl = false
                    }
                    else
                    {
                        if ((Mass_N_P[j]+1) != Mass_N_P[j+1])
                        {
                            nMNschArray[nSChN] = Mass_N_P[j+1]-Mass_N_P[j];
                            let Delt: Double = Double(NewRR[Mass_N_P[j]]-NewRR[Mass_N_P[j+1]])
                            nDsch += 1
                            nMNschArray[nSChN] = (round_i1(Delt*Double(nMNschArray[nSChN]) / 100.0));
                            if (nMNschArray[nSChN] != 0){
                                nSChN += 1
                            }
                        }
                        lFl = true
                    }
                }
                var nVN: Int
                var nVnn: Int
                var fSVos: Double = 0.0;
                var fSNis: Double = 0.0;
                if (nSChV>0){
                    for j in 0..<nSChV{
                        MVt[j] = nMVschArray[j];
                        nVN = j;
                        for i in 0..<nSChV{
                            if (nMVschArray[i]<MVt[j]){
                                MVt[j] = nMVschArray[i];
                                nVN = i;
                            }
                        }
                        fSVos += Double(nMVschArray[nVN])
                        nMVschArray[nVN] = 0xffff;
                    }
                    nVnn = MVt[nSChV-1];
                    for k in 0..<nVnn{
                        let zch: Int = labs(k-13+1);
                        for j in 0..<nSChV{
                            if (MVt[j] != 0){
                                if (k<13){
                                    nPyramideArray[zch] += 1
                                }
                            }
                        }
                        for j in 0..<nSChV{
                            if (MVt[j] != 0){
                                MVt[j] += -1
                            }
                        }
                    }
                }
                if (nSChN>0){
                    for j in 0..<nSChN{
                        MNt[j] = nMNschArray[j];
                        nVN = j;
                        for i in 0..<nSChN{
                            if (nMNschArray[i]<MNt[j]){
                                MNt[j] = nMNschArray[i];
                                nVN = i;
                            }
                        }
                        fSNis += Double(nMNschArray[nVN])
                        nMNschArray[nVN] = 0xffff;
                    }
                    let nNnn: Int = MNt[nSChN-1];
                    
                    for k in 0..<nNnn{
                        for j in 0..<nSChN{
                            if (MNt[j] != 0){
                                if (k<13){
                                    nPyramideArray[k+13] += 1
                                }
                            }
                        }
                        for j in 0..<nSChN{
                            if (MNt[j] != 0){
                                MNt[j] += -1
                            }
                        }
                    }
                }

            }
            lRet = true


        }

        return lRet
        }
    
    internal static func MtGetPrognozAvg(dHealth: Double,  nHour: Int, dClocksArray: inout [Double] /*[24]*/, nClocksArraySize: Int){
        
    }
    
    internal static func MtGetABCD(nClearRRArray: inout [Int], nCount: Int,
                                   dParamA: inout Double, dParamB: inout Double, dParamC: inout Double, dParamD: inout Double, dParamH: inout Double,
                                   dAvgRR: inout Double,  dIVR: inout Double, dVPR: inout Double,  dPAPR: inout Double, dIN: inout Double,
                                   nStartShift: Int=0 ) -> Bool{
        if( nClearRRArray.count==0 || nCount==0 ){
            return false
        }

        dParamA = 0
        dParamB = 0
        dParamC = 0
        dParamD = 0
        dParamH = 0
        dAvgRR = 0
        dIVR = 0
        dVPR = 0
        dPAPR = 0
        dIN = 0

        var nStartIndex: Int = 3 + nStartShift
        if (nStartIndex < 0 || nStartIndex>=nCount){
            nStartIndex = 0
        }

        var dModa: Double = 0.0
        var dAModa: Double = 0.0
        var dX: Double = 0.0

        var lRet: Bool = true

        if (nCount>5)
        {
            var c2: Double=0
            var dSKO: Double=0
            var nPir=[Int].init(repeating: 0, count: 26)

            MtInnerGetAB(nClearRRArray: &nClearRRArray, nCount: nCount, nStartIndex: nStartIndex, dRRsr: &dAvgRR, dMo: &dModa, dAMo: &dAModa, dDx: &dX, dSKO: &dSKO, dMb: &dParamB);
            
            _=dnaMath.MtGetPiram(nClearRRArray: &nClearRRArray, nCount: nCount, nPyramideArray: &nPir, dC2: &c2, fDelta: &dParamA, nStartPos: nStartIndex);

            dParamA = MtInnerNormalization(dParamA, g_CoeffA);
            dParamB = dParamB/1.0e04;
            dParamB = MtInnerNormalization(dParamB, g_CoeffB);
        }
        else{
            dAvgRR = Double(nClearRRArray[0])
            dModa = 1.0
            dAModa = 0.0
            dX = 1.0
            dParamA = 0.0
            dParamB = 0.0
            lRet = false
        }

        dIVR = (dAModa/dX)*1.0e05
        dVPR = dX/dModa
        dPAPR = (dAModa/dModa)*1.0e05
        dIN = (dAModa/(2*dX*dModa))*1.0e08

        if nCount>(56+nStartIndex) {
            var dSvnC: Double = 0.0
            var dSvnD: Double = 0.0
            //MARK: ПРОВЕРИТЬ
            //var nRR57Count: Int = Int( (nCount - ( 57.0 + Double(nStartIndex) ) / 11.0 ) + 1.0 )
            let nRR57Count: Int = Int( ( (Double(nCount)-(57.0+Double(nStartIndex)))/11.0 ) + 1.0)

            //
            var dSvnCArray = [Double].init(repeating: 0,count: nRR57Count)
            var dSvnDArray = [Double].init(repeating: 0,count: nRR57Count)

            if (dSvnCArray.count>0 && dSvnDArray.count>0){
                for i in 0..<nRR57Count{
                    let nStart: Int = i*11+nStartIndex
                    var nRR57Array=[Int].init(repeating:0,count:57)
                    for ii in nStart..<57+nStart{
                        nRR57Array[ii-nStart] = nClearRRArray[ii]
                    }

                    _=MtInnerGetSquareCD(nRR57Array: &nRR57Array, nCount: 57, dSC: &dSvnCArray[i], dSD: &dSvnDArray[i]);

                    dSvnC += dSvnCArray[i];
                    dSvnD += dSvnDArray[i];
                }

                dSvnC = dSvnC / Double(nRR57Count)
                dSvnD = dSvnD / Double(nRR57Count)

                var dDispC: Double = 0.0;
                var dDispD: Double = 0.0;
                
                for i in 0..<nRR57Count{
                    dDispC += ((dSvnCArray[i]-dSvnC)*(dSvnCArray[i]-dSvnC))
                    dDispD += ((dSvnDArray[i]-dSvnD)*(dSvnDArray[i]-dSvnD))
                }



                dDispC = dDispC / Double(nRR57Count)
                dDispD = dDispD / Double(nRR57Count)

                if (nRR57Count>1){
                    dParamC = dSvnC * dDispC
                     dParamC = dParamC / 1.0e08
                    dParamC = MtInnerNormalization(dParamC, g_CoeffC);
                }
                else{
                     dParamC = dSvnC/1.0e02;
                    dParamC = MtInnerNormalization(dParamC, g_CoeffCh);
                }

                dParamD = dSvnD;
                dParamD = dParamD/1.0e03;
                dParamD = MtInnerNormalization(dParamD, g_CoeffD);
            }
            else{
                dParamC = 0.0;
                dParamD = 0.0;
                lRet = false
            }
        }
        else{
            dParamC = 0.0;
            dParamD = 0.0;
            lRet = false
        }

        dParamH = (dParamA + dParamB + dParamC + dParamD) / 4.0;

        if (dParamA<0){
            dParamA = 0
        }
        if (dParamA>100.0){
            dParamA = 100.0
        }
        if (dParamB<0){
            dParamB = 0
        }
        if (dParamB>100.0){
            dParamB = 100.0
        }
        if (dParamC<0){
            dParamC = 0
        }
        if (dParamC>100.0){
            dParamC = 100.0
        }
        if (dParamD<0){
            dParamD = 0
        }
        if (dParamD>100.0){
            dParamD = 100.0
        }
        if (dParamH<0){
            dParamH = 0
        }
        if (dParamH>100.0){
            dParamH = 100.0
        }

        return lRet
        
    }
    
    internal static func MtGetABCDStrokes57(nRR57Array: inout [Int] /*57*/, nCount: Int,
                                            dParamA: inout Double, dParamB: inout Double, dParamC: inout Double, dParamD: inout Double, dParamH: inout Double) -> Bool{
        dParamA = 0
        dParamB = 0
        dParamC = 0
        dParamD = 0
        dParamH = 0

        if (nCount != 57){
            return false
        }
        
        // A & B
        var dMo: Double = 0
        var dAMo: Double = 0
        var dDx: Double = 0
        var dSKO: Double = 0
        var dRRsr: Double = 0
        var dC2: Double = 0
        var nPArray = [Int].init(repeating: 0, count: 26)

        dnaMath.MtInnerGetAB(nClearRRArray: &nRR57Array, nCount: nCount, nStartIndex: 0, dRRsr: &dRRsr, dMo: &dMo, dAMo: &dAMo, dDx: &dDx, dSKO: &dSKO, dMb: &dParamB)

        //dnaMath.MtGetPiram(nClearRRArray: &<#T##[Int]#>, nCount: <#T##Int#>, nPyramideArray: <#T##[Int]#>, nPyramideArraySize: <#T##Int#>, nStartPos: <#T##Int#>)
      
        _=dnaMath.MtGetPiram(nClearRRArray: &nRR57Array, nCount: nCount, nPyramideArray: &nPArray, dC2: &dC2, fDelta: &dParamA)

        dParamB = dParamB/1.0e04;
        dParamA = MtInnerNormalization(dParamA, g_CoeffA);
        dParamB = MtInnerNormalization(dParamB, g_CoeffB);
        // C & D
        _=dnaMath.MtInnerGetSquareCD(nRR57Array: &nRR57Array, nCount: nCount, dSC: &dParamC, dSD: &dParamD);

        dParamC = dParamC/1.0e02;
        dParamC = MtInnerNormalization(dParamC, g_CoeffCh);
        dParamD = dParamD/1.0e03;
        dParamD = MtInnerNormalization(dParamD, g_CoeffD);

        dParamH = (dParamA + dParamB + dParamC + dParamD) / 4.0;

        if (dParamA<0) {dParamA = 0}
        if (dParamA>100.0) {dParamA = 100.0}
        if (dParamB<0) {dParamB = 0}
        if (dParamB>100.0) {dParamB = 100.0}
        if (dParamC<0) {dParamC = 0}
        if (dParamC>100.0) {dParamC = 100.0}
        if (dParamD<0) {dParamD = 0}
        if (dParamD>100.0) {dParamD = 100.0}
        if (dParamH<0) {dParamH = 0}
        if (dParamH>100.0) {dParamH = 100.0}

        return true
    }
    
    internal static func MtGetCDStrokes57(nRR57Array: inout [Int] /*57*/, nCount: Int, dParamC: inout Double, dParamD: inout Double) -> Bool{

            dParamC = 0;
            dParamD = 0;

        if (nCount != 57){
            return false
        }
        
        _=dnaMath.MtInnerGetSquareCD(nRR57Array: &nRR57Array, nCount: nCount, dSC: &dParamC, dSD: &dParamD)

            dParamC = dParamC/1.0e02;
            dParamC = MtInnerNormalization(dParamC, g_CoeffCh);
            dParamD = dParamD/1.0e03;
            dParamD = MtInnerNormalization(dParamD, g_CoeffD);

        if (dParamC<0){ dParamC = 0}
        if (dParamC>100.0){ dParamC = 100.0}
        if (dParamD<0){ dParamD = 0}
        if (dParamD>100.0){ dParamD = 100.0}

            return true
            
        }
    
    internal static func MtVittaFilter(pRRList: inout [RR])->Int{

        var Cnt_V: Int = 0;

        if (pRRList.count>0){
            let dStep:Double = 40.0;
            let dBase:Double = 320.0;
            var nHistArray=[Int].init(repeating: 0, count: 50)
            
            var nClearRRCount: Int = 0;

            for pos in 0..<pRRList.count{
                if (pRRList[pos].mask == .good)
                {
                    nClearRRCount += 1
                }
            }

            if (nClearRRCount>150){
                var nMaxHist: Int = 0;
                var nIndex: Int;
                var nMaxN: Int = 0;
                for pos in 0..<pRRList.count{
                    if (pRRList[pos].mask == .good)
                    {
                        nIndex = Int((Double(pRRList[pos].rrValue)-dBase)/dStep)
                        if (nIndex<0){
                            nIndex = 0;
                        }
                        if (nIndex>49){
                            nIndex = 49;
                        }
                        nHistArray[nIndex] += 1;
                        if (nHistArray[nIndex]>nMaxHist)
                        {
                            nMaxHist = nHistArray[nIndex];
                            nMaxN = nIndex;
                        }
                    }
                }
                var lF: Bool = false
                //MARK: проверить границу в 0
                for i in stride(from: nMaxN, to: -1, by: -1){
                    if ((nHistArray[i]<5)&&(nHistArray[i]>0))
                    {
                        nHistArray[i] = 0;
                    }
                    else
                    {
                        nHistArray[i] = nHistArray[i]-4;
                    }
                    if (nHistArray[i] == 0)
                    {
                        lF=true
                    }
                    if ((nHistArray[i]<12)&&(nHistArray[i]>0)&&(lF))
                    {
                        nHistArray[i] = 0;
                    }
                }
                lF = false
                for i in nMaxN+1..<50{
                    if ((nHistArray[i]<5)&&(nHistArray[i]>0))
                    {
                        nHistArray[i] = 0;
                    }
                    else
                    {
                        nHistArray[i] = nHistArray[i]-4;
                    }
                    if (nHistArray[i] == 0)
                    {
                        lF = true
                    }
                    if ((nHistArray[i]<12)&&(nHistArray[i]>0)&&(lF))
                    {
                        nHistArray[i] = 0;
                    }
                }

                for pos in 0..<pRRList.count{
                    if (pRRList[pos].mask == .good)
                    {
                        nIndex = Int((Double(pRRList[pos].rrValue)-dBase)/dStep);
                        if (nIndex<0)
                        {
                            nIndex = 0;
                        }
                        if (nIndex>49)
                        {
                            nIndex = 49;
                        }
                        if (nHistArray[nIndex] <= 0)
                        {
                            //MARK: pRRList[pos].mask |= .vitta
                            pRRList[pos].mask = .vitta
                            Cnt_V += 1
                        }
                    }
                }
            }
        }

        return Cnt_V;
    }
    
    internal static func MtThresholdFilter(pRRList: inout [Int], nThreshold: Int=50)-> Int{
        return 0
    }
    
    internal static func MtGetSpline(dChainIntervalArray: [Double], nChainIntervalArraySize: Int,
                                     wSplainArray: inout [Int], nXdim: Int, nYdim: Int, nChainInterval: Int=5)->Bool{
        return true
    }
    
    internal static func  MtGetB2(nClearRRArray: inout [Int], nCount: Int)->Double{
        return 0
    }
    
    internal static func  MtGetD2(nClearRRArray: inout [Int], nCount: Int)->Double{
        return 0
    }
    
    internal static func  MtGetFraktalMatrix(dParamA: Double, pBitsMatrixArray: inout [Int], nMatrixSizeX: Int, nMatrixSizeY: Int,
                                             nBkColor: Int=0x00010101){
        
    }
    
    internal static func  MtGetMeridianValues(pRRArray: inout [Int], nMeridian: Int,
                                              dMeridianAverageValue: inout Double, dMeridianHiValue: inout Double, dMeridianLoValue: inout Double,
                                              pMeridianStrokesArray: inout [Double], lUseFilter: Bool=true)->Bool{
        
        return true
    }
    
    internal static func  MtGetMeridianValues(pRRArray: inout [Int], nMeridian: Int, dMeridianAverageValue: inout Double,
                                              lUseFilter: Bool=true)->Bool{
        return true
    }
    
    
    internal static func  MtGetSpectr2(nClearRRArray: inout [Int],pSpectrumArray: inout [Double], dVLF: inout Double, dLF: inout Double, dHF: inout Double, dTotal: inout Double){
        
        var dULF: Double = 0
        _=dnaMath.MtGetSpectr2(nClearRRArray: &nClearRRArray, nCount: nClearRRArray.count, pSpectrumArray: &pSpectrumArray, dULF: &dULF, dVLF: &dVLF, dLF: &dLF, dHF: &dHF, dTotal: &dTotal)
        dVLF += dULF;
    }
    
    
    internal static func  MtGetSpectr2(nClearRRArray: inout [Int], nCount: Int,
                                       pSpectrumArray: inout [Double], dULF: inout Double, dVLF: inout Double, dLF: inout Double, dHF: inout Double, dTotal: inout Double)->Bool{
        if (nClearRRArray.count == 0){
            return false
        }
        var fin=[Double].init(repeating: 0, count: 1024)
        var fout=[Double].init(repeating: 0, count: 1024)
        var foutimg=[Double].init(repeating: 0, count: 1024)
        
        for i in 0..<1024{
            fin[i] = Double(nClearRRArray[i%nCount])
        }
        var tempArr: [Double]=[]
        fft_double(1024, false, &fin, &tempArr, &fout, &foutimg);
        var re: Double
        var im: Double
        var dSpec: Double = 0;
        var dFreq: Double = 0;
        if (pSpectrumArray.count>0)
        {
            pSpectrumArray=[]
            pSpectrumArray.append(0)
        }
        for i in 1..<512{
            re = fout[i]/1024.0;
            im = foutimg[i]/1024.0;
            //get frequency intensity and scale to 0..256 range
            dSpec = (re*re+im*im)*2;
            if (pSpectrumArray.count>0){
                pSpectrumArray.append(dSpec)
            }
            dFreq = Double(i)/1024.0;
            if (dFreq>0.003)
            {
                if (dFreq <= 0.015)
                {
                    dULF += dSpec;
                }
                else
                {
                    if (dFreq <= 0.04)
                    {
                        dVLF += dSpec;
                    }
                    else
                    {
                        if (dFreq <= 0.15)
                        {
                            dLF += dSpec;
                        }
                        else
                        {
                            if (dFreq <= 0.4)
                            {
                                dHF += dSpec;
                            }
                        }
                    }
                }
            }
        }
        dTotal = dULF + dVLF + dLF + dHF;

        if (pSpectrumArray.count>0)
        {
            //Œ„Ë·‡˛˘‡ˇ
            dSpec = 0;
            var IndexesArray: [Int]=[]
            IndexesArray.append(0)
            var nPrev_i: Int = 0
            var dCur:Double
            var dNext:Double
            var dPrev:Double
            for i in 1..<511{
                dCur = pSpectrumArray[i]
                dNext = pSpectrumArray[i+1]
                if (dCur != dNext)
                {
                    if ((((dNext-dCur)*(dCur-dSpec)) < 0.0) && (dCur > dSpec))
                    {
                        IndexesArray.append(i-(i-nPrev_i)/2)
                    }
                    dSpec = dCur;
                    nPrev_i = i;
                }
            }

            var nIndexPrev: Int
            var nIndexCur: Int
            var dA1:Double
            var dA2:Double
            var dDeltA:Double
            for i in 1..<IndexesArray.count{
                nIndexPrev = IndexesArray[i-1]
                nIndexCur = IndexesArray[i]
                dPrev = pSpectrumArray[nIndexPrev]
                dCur = pSpectrumArray[nIndexCur]
                dDeltA = Double(nIndexPrev-nIndexCur);
                dA1 = (dPrev-dCur);
                dA2 = (dCur*Double(nIndexPrev) - dPrev*Double(nIndexCur))
                for j in nIndexPrev..<nIndexCur{
                    if (dDeltA != 0)
                    {
                         pSpectrumArray[j] = (dA1*Double(j)+dA2)/dDeltA
                    }
                }
            }
        }

        return true
    }
    

    
    internal static func  MtNormalizeSpectr(dVLF: inout Double, dLF: inout Double, dHF: inout Double, dTotal: inout Double){
        if (dTotal == 0)
        {
            dVLF = 0
            dLF = 0
            dHF = 0
        }
        else
        {
            dHF /= (dTotal/100.0)
            dLF /= (dTotal/100.0)
            dVLF /= (dTotal/100.0)
        }
    }
    
    internal static func  MtGetModa(pArray: inout [Double], dMo: inout Double, dAMo: inout Double, dBP: inout Double, nMoCoeff: Int=1)->Bool{
        return true
    }
    
    internal static func  MtGetModa(paArray: inout [Int], dMo: inout Double, dAMo: inout Double, dDx: inout Double, dSDNN: inout Double){
        
    }
    
    internal static func  MtGetMaxHR(nClearRRArray: inout [Int], nCount: Int, fMaxHR: inout Double)->Bool{
        return true
    }
    
    
    
    internal static func  MtGetAKG(nClearRRArray: inout [Int], nCount: Int, pAKGArray: inout [Double], dblK1: inout Double, dblM0: inout Double)->Bool{
        return true
    }
    
    
    internal static func  MtGetACP(pClearRrArray: inout [Int], dRad: inout [Double]/*[100]*/, lcol: inout [Int]/*[100]*/, lmaxColRad: inout Int){
        
    }
    
    
    internal static func  MtGetACP(pClearRrArray: inout [Int], dRad: inout [Double]/*[100]*/, lcol: inout [Color]/*[100]*/, lmaxColRad: inout Int, RMSSD: inout Double, NN50: inout Double,pNN50: inout Double, HRVind: inout Int){
        // acp
        if(pClearRrArray.count==0){
            return
        }
        dRad=[Double].init(repeating: 0, count: 100)
        lcol=[Color].init(repeating: Color.white, count: 100)
        let dwClearRRCount: Int = pClearRrArray.count
        var ind=[Double].init(repeating: 0, count: 500)
        for i in 0..<500{
            if (i < dwClearRRCount){
                ind[i] =  Double(pClearRrArray[i]) / 1000.0
            }
            else{
                ind[i] = 0.0
            }
        }

        var R: Int = 0;
        var G: Int = 0;
        var B: Int = 0;
        var ch: Int = 0;
        var m_ColorMass: [Color] = [Color].init(repeating: Color.white, count: 1280)

        
        for k in 0..<5{
            for i in 0..<256{
                switch(k)
                {
                case 0:
                    R=0;
                    G=i;
                    B=255;

                case 1:
                    R=0;
                    G=255;
                    B=255-i;

                case 2:
                    R=i;
                    G=255;
                    B=0;

                case 3:
                    R=255;
                    G=255-i;
                    B=0;

                case 4:
                    R=255-i;
                    G=0;
                    B=0;

                default:
                    break
                }

                if (ch>=0 && ch<1280){
                    m_ColorMass[ch] = Color(red: Double(R), green: Double(G), blue: Double(B))
                }
                ch += 1
            }
        }

        //////////////////////////////////////////////////////////////////////////
        //Hst creating
        var Hst=[Int].init(repeating: 0, count: 35)
        var Hst_8=[Int].init(repeating: 0, count: 175)

        
        var dw: Int=0
        for i in 0..<dwClearRRCount{
            dw = pClearRrArray[i]
            if ((dw >= 300) && (dw < 1700)){
                Hst[(dw - 300) / 40] += 1
            }
        }

        //////////////////////////////////////////////////////////////////////////
        var m_eiMy: Double = 0
        var m_eiMy_Pr: Double = 0
        var deLta: Double = 0
        var index: Int = 0;
        var kol_voRMSSD: Double = 0
        var SDSD: Double = 0
        RMSSD = 0
        NN50 = 0
        
        while (index < dwClearRRCount)
        {
            dw = pClearRrArray[index]
            m_eiMy = Double(dw) / 1000.0
            if (index > 0)
            {
                deLta = m_eiMy-m_eiMy_Pr;
                if ((fabs(deLta)>0.050) || (fabs(deLta)==0.050)){
                    NN50 += 1
                }
                RMSSD+=deLta*deLta*1000000;
                kol_voRMSSD += 1

                SDSD+=fabs(deLta);
            }
            m_eiMy_Pr = m_eiMy;
            if (((dw - 280) / 8) < 35){
                if (dw >= 280){
                    Hst[(dw - 280) / 8] += 1
                }
            }
            if (((dw - 280) / 8) < 175)
            {
                if (dw >= 280){
                    Hst_8[(dw - 280) / 8] += 1
                }
            }
            index += 1
        }
        pNN50 = NN50 * 100.0 / Double(dwClearRRCount)
        RMSSD=sqrt(RMSSD/kol_voRMSSD);

        //////////////////////////////////////////////////////////////////////////

        var j_max40: Int = 0
        var m_nMo: Int = Hst[0];
        HRVind = Hst_8[0];
        var l: Int = 0;
        //var Mo: Double = 0.28;
        
        for i in 0..<35{
            if (Hst[i] > m_nMo)
            {
                m_nMo = Hst [i];
                //Mo = 0.28 + Double(i) * 0.04;
                j_max40 = i;
            }
            for _ in 0..<5{
                if ((Hst_8[l]) > HRVind)
                {
                    HRVind = Hst_8[l];
                }
                l += 1
            }
        }
        //let Amo: Double = Double(m_nMo) / Double(dwClearRRCount)
        var RRmax: Double = 0
            var RRmin: Double = ind[0]
        
        for i in 0..<dwClearRRCount{
            if (Double(ind[i])>RRmax){
                RRmax=Double(ind[i])
            }
            if (Double(ind[i])<RRmin){
                RRmin=Double(ind[i])
            }
        }
        if (RRmin == RRmax){
            RRmin = RRmax - 1.0
        }

        HRVind = Int((Double(dwClearRRCount))/Double(HRVind) + 0.5)
        //var BP: Double = 1000.0 * (RRmax - RRmin);
        //var m_Amo: Double = Amo * 100;
        var jj: Int = j_max40;
        var ii: Int = j_max40;
        var ni: Double
        var nj: Double
        
        while ((Hst[ii] != 0) || (ii == -1)){
        ii -= 1
        }
        while ( (Hst[jj] != 0) || (jj == 35) ){
            jj += 1
        }
        if (j_max40>0){   // MX:bug{
            ii += 1
            jj -= 1
        }
        ni=Double(j_max40-ii)
        nj=Double(jj-j_max40)
        var tekRad: Double = 70.5;
        var Summ_Hst: Int = 0;
        var Vozr_m=[Int].init(repeating: 0, count: 35)
        var Temp_Hst=[Int].init(repeating: 0, count: 35)
        
        var ind_kk: Int = 0
        var max_Hst: Int
        for kk1 in 0..<Int(ni+nj+1){
            if( ( kk1 >= 0 ) && ( kk1 < 35 ) ){
                if( ( ( kk1+ii ) >= 0 ) && ( ( kk1+ii ) < 35 ) ){
                    Temp_Hst[ kk1]=Hst[ kk1 + ii]
                }
            }
        }

        for kk1 in 0..<Int(ni+nj+1){
            max_Hst=999;
            for kk2 in 0..<Int(ni+nj+1){
                if (kk2>=0 && kk2<35){
                    if (Temp_Hst[kk2]<=max_Hst){
                        max_Hst=Temp_Hst[kk2]
                        ind_kk=kk2
                    }
                }
            }
            if (kk1>=0 && kk1<35){
                Vozr_m[kk1]=max_Hst;
            }
            Summ_Hst+=max_Hst;
            if (ind_kk>=0 && ind_kk<35)
            {
                Temp_Hst[ind_kk]=10000;
            }
        }

        let m_First: [Int] = [768,768,768,768,576,384,192,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        let m_Last: [Int] = [1023,1023,1023,1023,1023,895,767,767,767,767,767,767,767,767,767,767,767,767,767,
            767,767,767,767,767,767,767,767,767,767,767]
        var ind_ni_nj: Int = Int(ni+nj+1)
        if (ind_ni_nj>29){
            ind_ni_nj=29
        }
        
        var m_CutMass=[Color].init(repeating: Color.white, count: 1024)
        let m_ttt:Int = m_Last[ind_ni_nj]+257;

        for i in m_First[ind_ni_nj]..<m_ttt{
            if (i<0 || i>=1280){
                continue
            }
            m_CutMass[i-m_First[ind_ni_nj]] = m_ColorMass[i];
        }
        
        let RaznFL: Int = m_Last[ind_ni_nj]-m_First[ind_ni_nj];
        var in_PrCol: Int = 0
        ch=0;
        var RadPr: Double = 0.0;
        var RaznSum: Double = Double(Summ_Hst)
        for  k in 0..<Int(ni+nj+1){
            if (k<0 || k>=35) {
                continue
            }
            var in_: Int = round_i1( (Double(RaznFL)*(Double(Vozr_m[k]) - 5.0)) / 186.0 )
            if (in_>RaznFL){
                in_=RaznFL
            }
            if (in_<0){
                in_=0
            }

            if (k>0)
            {
                var Summ_Col: Double=Double(in_PrCol)
                var tRad: Double=RadPr-1.0;
                while (tRad>=tekRad)
                {
                    if (ch >= 0 && ch < 100){

                    if(  RadPr - tekRad  >= 1.0 ){
                        //MARK:                         Summ_Col = Summ_Col + (((in_ - Double(in_PrCol))-1.0) / floor((RadPr)-tekRad))
                        Summ_Col = Summ_Col +  (Double(in_) - Double(in_PrCol) - 1.0 ) /  (Double(RadPr) - Double(tekRad) ).rounded(.toNearestOrAwayFromZero)

                    }
                    dRad[ch]=tRad;
                    if (Summ_Col<0){
                        Summ_Col=0
                    }
                    if (Summ_Col>1023){
                        Summ_Col=1023
                    }
                        let sc: Int = round_i1(Summ_Col);
                    if (sc<0 || sc>=1024) {
                        continue
                    }
                    lcol[ch] = m_CutMass[sc];
                    ch += 1
                    tRad=tRad-1.0;
                }
                }
            }
            if (ch<0 || ch>=100) {
                continue
            }
            dRad[ch]=tekRad;
            RadPr=tekRad;
            if (in_<0 || in_>=1024){
                continue
            }
            lcol[ch]=m_CutMass[in_];
            in_PrCol=in_;
            ch += 1
            if (k<0 || k>=35){
                continue
            }
            RaznSum=RaznSum-Double(Vozr_m[k])
            if( Summ_Hst > 0){
                tekRad = ( (RaznSum*70.5) / Double(Summ_Hst))
            }
        }
        
        var Summ_Col: Double = Double(in_PrCol)
        for tRad in stride(from: (RadPr-1.0), to: -1, by: -1){
            if(  Double(RadPr) - Double(tekRad)  >= 1.0 ){
                    Summ_Col=Summ_Col+((254)/floor((RadPr)-tekRad))
            }
            if (ch>=0 && ch<100){
                    dRad[ch]=tRad
            }
            let sc: Int = round_i1(Summ_Col)
            if (sc<0 || sc>=1024){
                continue
            }
            if (ch>=0 && ch<100){
                    lcol[ch] = m_CutMass[sc]
            }
                ch += 1
            }
        
        lmaxColRad = ch;
    }
    
    
    internal static func  MtGetWaveSpectrum(pClearRrArray: inout [Int], Spek: inout [Double]/*150*/){
        let dwClearRRCount: Int = pClearRrArray.count
        if(dwClearRRCount == 0){
            return
        }
        Spek=[Double].init(repeating: 0, count: 150)
        let NN: Int = 300
        var mRr = [Double].init(repeating: 0, count: 300)
        var m_MOg: Double = 0.0
        for id in 0..<NN{
            m_MOg = m_MOg + Double(pClearRrArray[id%dwClearRRCount])/1000.0
            mRr[id] = 0.0;
        }
        m_MOg = m_MOg / Double(NN)
        for mRo in 0..<NN{
            for id in 1..<NN-mRo{
                mRr[mRo] += ((( Double(pClearRrArray[id%dwClearRRCount]) / 1000.0) - m_MOg) * (( Double(pClearRrArray[ (id+mRo)%dwClearRRCount ]) / 1000.0) - m_MOg))
            }
            mRr[mRo] = mRr[mRo] / Double(NN)
        }
        let KK: Int = 150;
        var SuMM: Double
        for _j in 0..<KK{
            SuMM=0.0;
            for mRo in 1..<NN{
                SuMM += Double(mRr[mRo]*(0.54+0.46 * cos((Double.pi*Double(mRo))/Double(NN)))*cos((Double.pi*Double(mRo)*Double(_j))/Double(KK)))
            }
            Spek[_j]=(2*m_MOg*(mRr[0]+2*SuMM))
        }
        
    }
    
    
    internal static func  MtGetBrain(pClearRrArray: inout [Int], fAvgD: inout Double, pBrain: inout [Int]){
        
    }
    
    
    internal static func  MtGetPhaseSpectrum(IN pClearRrArray: inout [Int], pPhaseSpectrumArray: inout [Int]){
        
    }
    
    
    internal static func  MtGetPhaseSpectrum(IN pClearRrArray: inout [Int], pPhaseSpectrumArray:  inout [[Int]]){
        
    }
    
    
    //    func  DMGetPhasePortrait(CDC *dcMet,long m_Px,long m_Py,BOOL delete_All_Var,long *m_pCRR=NULL,long m_Count=0)->Int{
    //
    //    }
    
    
    internal static func  MtGetPQRST(pComplex: inout [Int]/*[800]*/,
                                     nPeakP: inout Int, nPeakQ: inout Int, nPeakR: inout Int, nPeakS: inout Int,
                                     nPeakT: inout Int,
                                     nQRS: inout Double,  nPR: inout Double, nQT: inout Double,
                                     nAmplP: inout Double, nAmplR: inout Double, nAmplT: inout Double){
        
    }
    
    
    internal static func  MtGetPQRST(pComplex: inout [Int]/*[800]*/,
                                     nPeakP: inout Int, nPeakQ: inout Int, nPeakR: inout Int, nPeakS: inout Int,
                                     nPeakT: inout Int,
                                     nQRS: inout Double,  nPR: inout Double, nQT: inout Double, nIsoline: inout Double){
        
    }
    
    
    internal static func  DMGetPQRST1(m_PQRSTarr: inout [Int] /*800*/, P: inout Int, Q: inout Int, R: inout Int, S: inout Int, T: inout Int,
                                      QRS: inout Double, PR: inout Double, QT: inout Double, aP: inout Double, aR: inout Double, aT: Double){
        
    }
    
    
    
    func  MtRtInit(){
        
    }
    
    func  MtRtIsRRPeak(nEcgValue: Int, nPeakShift: inout Int)->Bool{
        nPeakShift = 0
        mt_dEcgArray[ (mt_nCntECG + mt_dwIC) % mt_nCntECG ] = Double(nEcgValue)
        mt_dECGKorrArray[ (mt_nCntECG+mt_dwIC) % mt_nCntECG ] = Double(nEcgValue)
        mt_nTotalCount += 1
        mt_nCurrentLen += 1
        mt_nCurL += 1
        if (mt_nCurL>2000)
        {
            mt_lEntHere = true
        }
        var lFlagRR2 = false
        if ((mt_nCurrentLen ==  350) && (mt_dwIC > Int(mt_nCntECG - 1 - Int(mt_dKSArray[3]) + 350 ) ) )
        {
            lFlagRR2 = true
        }
        var lFlagRR = true

        if (mt_dwIC >= 31)
        {
            mt_dEcgArray[(mt_nCntECG-15+mt_dwIC)%mt_nCntECG] = mt_dKSArray[12]*mt_dEcgArray[(mt_nCntECG-15+mt_dwIC)%mt_nCntECG]+(1-mt_dKSArray[12])*mt_dEcgArray[(mt_nCntECG-16+mt_dwIC)%mt_nCntECG]
            mt_dEcgArray[(mt_nCntECG-16+mt_dwIC)%mt_nCntECG] = mt_dKSArray[13]*mt_dEcgArray[(mt_nCntECG-16+mt_dwIC)%mt_nCntECG]+(1-mt_dKSArray[13])*mt_dEcgArray[(mt_nCntECG-17+mt_dwIC)%mt_nCntECG]
            if (mt_dwIC > 38)
            {
                mt_dEcgArray[(mt_nCntECG-39+mt_dwIC)%mt_nCntECG] = mt_dMnG1*mt_dEcgArray[(mt_nCntECG-17+mt_dwIC)%mt_nCntECG];
            }
            if (mt_nTotalCount > 305)
            {
                if (mt_nLen>0)
                {
                    mt_nLen -= 1
                    lFlagRR = false
                }
                if (lFlagRR)
                {
                    if ( ( ( mt_dEcgArray[ (Int(mt_dKSArray[3]) + 1 + mt_dwIC ) % mt_nCntECG ] - mt_dEcgArray[(Int(mt_dKSArray[3])+mt_dwIC) % mt_nCntECG]) *
                        (mt_dEcgArray[(Int(mt_dKSArray[3]) + 2 + mt_dwIC ) % mt_nCntECG] - mt_dEcgArray[(Int(mt_dKSArray[3]) + 1 + mt_dwIC) % mt_nCntECG]) < 0) &&
                        ((mt_dEcgArray[(Int(mt_dKSArray[3]) + 2 + mt_dwIC) % mt_nCntECG] - mt_dEcgArray[(Int(mt_dKSArray[3])+1+mt_dwIC)%mt_nCntECG])<0))
                    {
                        if ((mt_dwIC<3000)||(mt_lEntHere))
                        {
                            var dMaximum = 0.0
                            var dMinimum = 1000000.0
                            var dVArray: [Double]=[Double].init(repeating: 0, count: 166)
                            var dVArrayCounter: Int = 0
                            for i in 800..<1800{
                                if (mt_dECGKorrArray[(i+mt_dwIC+1)%mt_nCntECG] > dMaximum)
                                {
                                    dMaximum = mt_dECGKorrArray[(i+mt_dwIC+1)%mt_nCntECG]
                                }
                                if ((mt_dECGKorrArray[(i+mt_dwIC+1)%mt_nCntECG] < dMinimum) && (mt_dECGKorrArray[(i+mt_dwIC+1)%mt_nCntECG] > 0.0))
                                {
                                    dMinimum = mt_dECGKorrArray[(i+mt_dwIC+1)%mt_nCntECG]
                                }
                                if ((i%6) == 0)
                                {
                                    dVArray[dVArrayCounter] = mt_dECGKorrArray[(i+mt_dwIC+1)%mt_nCntECG]
                                    dVArrayCounter += 1
                                }

                            }
                            if (dMaximum != dMinimum)
                            {
                                mt_dMnG = ((800.0/(dMaximum-dMinimum)));
                            }

                            var dXXArray: [Double] = [Double].init(repeating: 0, count: 3)
                            var dYYArray: [Double] = [Double].init(repeating: 0, count: 3)
                                
                            for k in 0...2{

                                let nBG: Int = k*55/*CnT_*/;
                                let nEnDA: Int = nBG+54/*CnT_-1*/;
                                let nEnD: Int = 27+nBG; //(long)(((double)(CnT_-1))/2.0)+nBG;
                                
                                for i in nBG...nEnD{
                                    for j in i...nEnDA{
                                        if (dVArray[j] <= dVArray[i]){
                                            let dTemp: Double = dVArray[i]
                                            dVArray[i] = dVArray[j]
                                            dVArray[j] = dTemp;
                                        }
                                    }
                                }
                                dYYArray[k] = dVArray[nEnD]
                                dXXArray[k] = Double(nEnD)
                            }
                            var dMM: Double = 0.0
                            if (dXXArray[2] != dXXArray[0]){
                                dMM = (dYYArray[2]-dYYArray[0])/(dXXArray[2]-dXXArray[0]);
                            }
                            let dBB: Double = ((dYYArray[0]+dYYArray[1]+dYYArray[2])/3.0)-dMM*((dXXArray[0]+dXXArray[1]+dXXArray[2])/3.0)
                            if (mt_dwIC<1200){
                                mt_dMnG1 = mt_dMnG
                            }
                            else{
                                if (dMM != 0.0){
                                    if ((fabs(dBB/dMM))>60000.0){
                                        mt_dMnG1 = mt_dMnG
                                    }
                                }
                                else{
                                    mt_dMnG1 = mt_dMnG
                                    mt_lEntHere = false
                                }
                            }

                        }

                        var dAvgDelta1: Double = mt_dEcgArray[(Int(mt_dKSArray[1])+1+mt_dwIC) % mt_nCntECG] - mt_dEcgArray[(Int(mt_dKSArray[0])+1+mt_dwIC)%mt_nCntECG]
                        var dAvgDelta2: Double = mt_dEcgArray[(Int(mt_dKSArray[4])+1+mt_dwIC)%mt_nCntECG]-mt_dEcgArray[(Int(mt_dKSArray[5])+1+mt_dwIC)%mt_nCntECG]
                        var nSchC: Int = 1
                        
                        for i in stride(from: Int(mt_dKSArray[1])+2, through: Int(mt_dKSArray[3])-2, by: 2){
                            dAvgDelta1 = (dAvgDelta1+mt_dEcgArray[(i+1+mt_dwIC)%mt_nCntECG]-mt_dEcgArray[(i-1+mt_dwIC)%mt_nCntECG])

                            dAvgDelta2 = (dAvgDelta2+mt_dEcgArray[((2*Int(mt_dKSArray[3])-i)+1+mt_dwIC)%mt_nCntECG]-mt_dEcgArray[((2*Int(mt_dKSArray[3])-i)+3+mt_dwIC)%mt_nCntECG])
                            nSchC += 1
                        }
                        dAvgDelta1 = dAvgDelta1/Double(nSchC)
                        dAvgDelta2 = dAvgDelta2/Double(nSchC)

                            if ((dAvgDelta1>=mt_dKSArray[15]) || (dAvgDelta2>=mt_dKSArray[15])){
                                lFlagRR = true
                            }
                            else
                            {
                                lFlagRR = false
                            }
                    }
                    else
                    {
                        lFlagRR = false
                    }
                }
            }
            else{
                mt_nLen = 0
                mt_nCurrentLen = 0
                lFlagRR = false
            }
            if ((lFlagRR) && (mt_dwIC>Int(mt_nCntECG-1-Int(mt_dKSArray[3])))){
                if (mt_nCurrentLen < 350){
                    lFlagRR = false
                    if (fabs(mt_dPsrRR-Double(mt_nPrCurrentLen)) > fabs(mt_dPsrRR-Double(mt_nPrCurrentLen+mt_nCurrentLen))){
                        mt_nCurrentLen = 0
                    }
                }
                else{
                    lFlagRR = false
                    mt_nMaxLen = Int(Double(mt_nCurrentLen) * 0.9)
                    let dDelta: Double = fabs(Double(mt_nMaxPrev) - Double(mt_nCurrentLen)*0.9)
                    let dProc: Double = fabs(Double(mt_nMaxPrev) * 0.1)
                    if (dDelta > dProc){
                        mt_nMaxLen = Int(Double(mt_nMaxPrev) * 0.9)
                    }
                    mt_nLen = Int(Double(mt_nMaxLen) / 2)
                    mt_nMaxPrev = mt_nMaxLen
                    mt_nPrCurrentLen = mt_nCurrentLen
                    mt_nCurrentLen = 0
                }
            }
            if (lFlagRR2){
                //let nP: Int = 0
                mt_nSm = mt_nCntECG-1-Int(mt_dKSArray[3])+350
                var nSmArray: [Int] = [Int].init(repeating: 0, count: 2)
                nSmArray[0] = mt_nSm
                var nZnak: Int = 1
                var dTekZn: Double = mt_dECGKorrArray[(mt_nCntECG-mt_nSm+mt_dwIC)%mt_nCntECG]
                if (dTekZn < mt_dECGKorrArray[(mt_nCntECG-(mt_nSm-1)+mt_dwIC)%mt_nCntECG])
                {
                    nZnak = -1
                }
                for i in 0..<2{
                    while ((mt_dECGKorrArray[(mt_nCntECG-nSmArray[i]+mt_dwIC)%mt_nCntECG]) >= dTekZn)
                    {
                        dTekZn = mt_dECGKorrArray[(mt_nCntECG-nSmArray[i]+mt_dwIC)%mt_nCntECG]
                        nSmArray[i] = nSmArray[i]+nZnak
                    }
                    dTekZn = mt_dECGKorrArray[(mt_nCntECG-nSmArray[i]+mt_dwIC)%mt_nCntECG]
                    nSmArray[1] = nSmArray[i]
                    if (nZnak == 1)
                    {
                        nZnak = -1
                    }
                    else
                    {
                        nZnak = 1
                    }
                }
                mt_nSm = nSmArray[0]-Int(Double((nSmArray[0]-nSmArray[1]))/2.0)
                nPeakShift = mt_nSm
                if (mt_nRR>699){
                    mt_nRR = 699
                }
                mt_nRR += 1
                if (mt_nRR == 1){
                    mt_nRRt = mt_dwIC-mt_nSm
                    mt_dwPrTochnZnRR = mt_nRRt
                }
                else{
                    mt_nRRt = mt_dwIC - mt_nSm
                    mt_nRRt = mt_nRRt - mt_dwPrTochnZnRR
                    mt_dwPrTochnZnRR = mt_dwPrTochnZnRR + mt_nRRt
                }
                lFlagRR = true
                if (mt_nRR>1){
                    mt_dPsrRR = (Double(mt_nRRt)+mt_dPsrRR)/2.0
                }
                else
                {
                    mt_dPsrRR = Double(mt_nRRt)
                }
                mt_nCurL = 0
            }
        }
        else{
            lFlagRR = false
        }
        mt_dwIC += 1
        //MARK: ПРОВЕРИТЬ
        if (nPeakShift==0){
            lFlagRR = false
        }
        return lFlagRR
        
    }
    
    
    func  MtRtGetABCDStrokes(dRetA: inout Double, dRetB: inout Double, dRetC: inout Double, dRetD: inout Double, dRetH: inout Double,
                             nRetRR: inout Int, lIsItArtefact: inout Bool, lIsNewValues: inout Bool, nPulseRate: inout Int, dAverageRR: inout Double, lNotRRPeak: Bool = true, nMinFilter: Int=400){
        
        var SKO: Double = 0.0
        var deltaRR: Double
        var deltaRR1: Double
        
        if (!lNotRRPeak){
            mt_nRR += 1
            mt_nRRt = nRetRR;
        }
        lIsItArtefact = true;
        lIsNewValues = false;

        if (mt_nRR <= 4){
            mt_dAverageRR = Double(mt_nRRt)
            if (mt_nRR < 4){
                mt_AvgRR1 = mt_dAverageRR;
            }
            if (mt_nRR == 4){
                mt_dAverageRR = (mt_AvgRR1+mt_dAverageRR)/2.0;
            }

            mt_nPrevRR = mt_nRRt;
        }
        else{
            if ((mt_nRRt<nMinFilter) || (mt_nRRt>2000) ||
                (mt_nPrevRR != 0 && (abs(mt_nRRt-mt_nPrevRR) > Int((Double(mt_nPrevRR))*0.40))) ){
                lIsItArtefact = false
                mt_nPrevRR = 0;
            }
            else
            {

                if (mt_nPrevRR == 0){
                     mt_nPrevRR = mt_nRRt;
                }

                if (mt_dAverageRR != 0.0){
                    deltaRR = fabs(Double(mt_nRRt) / Double(mt_dAverageRR))
                }
                else{
                    deltaRR = 0.0;
                }

                if ((deltaRR < 0.7) || (deltaRR > 1.3)){
                    lIsItArtefact = false
                }
                else{
                    mt_nPrevRR = mt_nRRt
                }

                if ((mt_nRR >= 3) && (mt_nRR57 < 10)){
                    if (lIsItArtefact){
                        for _move_ in 0..<56{
                            mt_nRR57Array[_move_] = mt_nRR57Array[_move_+1];
                        }
                        
                        mt_nRR57Array[56] = mt_nRRt
                        mt_nRR57 += 1
                        mt_dAverageRR += Double(mt_nRRt)
                        mt_dAverageRR /= 2.0
                        mt_nRRiCounter = 0

                        if (mt_nRR57 == 10){
                            var minAvg: Double = Double(mt_nRR57Array[47])
                            var maxAvg: Double = Double(mt_nRR57Array[47])
                            var modeValues: [Double]=[Double].init(repeating: 0, count: 4)
                            var modeCounters: [Int] = [Int].init(repeating: 0, count: 3)
                            
                            for count in 47..<57{
                                if (Double(mt_nRR57Array[count]) > maxAvg){
                                    maxAvg = Double(mt_nRR57Array[count])
                                }
                                if (Double(mt_nRR57Array[count]) < minAvg){
                                    minAvg = Double(mt_nRR57Array[count])
                                }
                            }
                            let step: Double = (maxAvg - minAvg) / 3.0;
                            if (step > 0.0){
                                var count: Int = 0
                                for count in 0..<3{
                                    modeValues[count] = minAvg + (Double(count)) * step
                                }
                                modeValues[3] = maxAvg + 1.0;
                                for count in 47..<57{
                                    var index: Int = Int((Double(mt_nRR57Array[count]) - minAvg) / step)
                                    if (index < 0){
                                        index = 0
                                    }
                                    if (index > 2){
                                        index = 2
                                    }
                                    modeCounters[index] += 1
                                }
                                var maxCounters: Int = modeCounters[0]
                                var _count: Int = 0
                                
                                for count in 0..<3{
                                    if (modeCounters[count] > maxCounters){
                                        _count = count;
                                        maxCounters = modeCounters[count];
                                    }
                                }
                                count = _count
                                minAvg = modeValues[count]
                                maxAvg = modeValues[count + 1]
                                mt_dAverageRR = 0.0
                                
                                for i in 47..<57{
                                        if ((Double(mt_nRR57Array[i])>=minAvg) && (Double(mt_nRR57Array[i])<maxAvg)){
                                            mt_dAverageRR += Double(mt_nRR57Array[i])
                                        }
                                }
                                mt_dAverageRR /= Double(modeCounters[count])
                            }
                            else{
                                mt_dAverageRR = minAvg
                            }
                        }
                    }
                }
                else
                {
                    if (mt_dAvgRRs != 0.0){
                        deltaRR1 = fabs(Double(mt_nRRt) / Double(mt_dAvgRRs))
                    }
                    else{
                        deltaRR1 = 0.0;
                    }

                     if ( (!lIsItArtefact) && ((deltaRR1 < 0.7) || (deltaRR1 > 1.3)) ){
                        lIsItArtefact = false
                        if (mt_nLastRRi == mt_nRR-1){
                            mt_nRRiCounter += 1
                        }
                        else{
                            mt_nRRiCounter = 0;
                        }
                        if (mt_nRRiCounter>2){
                            mt_nRRz57 += 1
                            mt_dAvgRRs = mt_dAverageRR
                            mt_dAverageRR += Double(mt_nRRt)
                            mt_dAverageRR /= 2.0;
                            deltaRR = mt_dAvgRRo/Double(mt_nRRt)
                            if ((deltaRR < 0.8)){
                                mt_dAverageRR = mt_dAverageRR - 2*deltaRR;
                            }
                            if ((deltaRR > 1.2)){
                                mt_dAverageRR = mt_dAverageRR + 2*deltaRR;
                            }
                        }
                        mt_nLastRRi = mt_nRR;
                    }
                    else
                    {
                        for _move_ in 0..<56{
                            mt_nRR57Array[_move_] = mt_nRR57Array[_move_+1];
                        }
                        mt_nRR57Array[56] = mt_nRRt;
                        mt_nRR57 += 1
                        if ((mt_nRR57 == 57) || (mt_nRRz57 == 11)){
                            mt_nRRz57 = 0;
                            let StartInd: Int = 0
                            let m_Count: Int = 57;
                            var Mo: Double=0
                            var AMo: Double=0
                            var dX: Double=0
                            var RR_sr: Double=0

                            var a_: Double=0
                            var b_: Double=0
                            var c_: Double=0
                            var d_: Double=0
                            var h_: Double=0

                            dnaMath.MtInnerGetAB(nClearRRArray: &mt_nRR57Array, nCount: m_Count, nStartIndex: StartInd, dRRsr: &RR_sr, dMo: &Mo, dAMo: &AMo, dDx: &dX, dSKO: &SKO, dMb: &b_)
                            
                            var c2: Double=0
                            var m_Pir: [Int] = [Int].init(repeating: 0, count: 26)
                            
                            
                            //MARK: проверить передаваемые параметры
                            _=dnaMath.MtGetPiram(nClearRRArray: &mt_nRR57Array, nCount: m_Count, nPyramideArray: &m_Pir, dC2: &c2, fDelta: &a_)

                            b_ = b_ / 1.0e04;
                            a_ = dnaMath.MtInnerNormalization(a_, g_CoeffA)
                            b_ = dnaMath.MtInnerNormalization(b_, g_CoeffB)

                            _=dnaMath.MtInnerGetSquareCD(nRR57Array: &mt_nRR57Array, nCount: m_Count, dSC: &c_, dSD: &d_)

                            c_ = c_/1.0e02;
                            c_ = dnaMath.MtInnerNormalization(c_, g_CoeffCh);
                            d_ = d_/1.0e03;
                            d_ = dnaMath.MtInnerNormalization(d_, g_CoeffD);

                            dAverageRR = RR_sr;

                            h_ = (a_ + b_ + c_ + d_)/4;
        
                            dRetA = a_;
                            dRetB = b_;
                            dRetC = c_;
                            dRetD = d_;
                            dRetH = h_;

                            lIsNewValues = true;
                        }
                        mt_nRRz57 += 1
                        mt_dAvgRRs = mt_dAverageRR;
                        mt_dAverageRR += Double(mt_nRRt)
                        mt_dAverageRR /= 2.0;
                        deltaRR = mt_dAvgRRo / Double(mt_nRRt)
                        if ((deltaRR < 0.8)){
                            mt_dAverageRR = mt_dAverageRR - 2*deltaRR
                        }
                        if ((deltaRR > 1.2)){
                            mt_dAverageRR = mt_dAverageRR + 2*deltaRR
                        }
                    }
                }
            }
        }
        mt_dAvgRRo = mt_dAverageRR
        nPulseRate = Int(60000 / mt_dAverageRR)
        dAverageRR = mt_dAverageRR
        nRetRR = mt_nRRt
        
    }
    
    
    internal static func  MtGetMeridiansFromSpectr(nClearRRArray: inout [Int], nCount: Int, dMeridianValuesArray: inout [Double] /*[12]*/)->Bool{
        return true
    }
    
    
    
    //    internal static func  MtGetBodyFreqFromSpectr(nClearRRArray: inout [Int], nCount: Int,
    //                                                      OUT MT_BODY_FREQ stBodyFreqValuesArray[9], dTotal: inout DoubleSpectrValue)->Bool{
    //
    //    }
    
    internal static func  MtGetTotalScoreFromSpectr(nClearRRArray: inout [Int], nCount: Int, dTotalScore: inout Double)->Bool{
        return true
    }
    
    
    internal static func  MtGetScoresFromSpectr(nClearRRArray: inout [Int], nCount: Int,
                                                dScore: inout [Double]/*[9]*/, dTotalScore: inout Double, dLFHfValue: inout Double, dTpValue: inout Double)->Bool{
        return true
    }
    
    internal static func CorrectMeridians(fMeridians: inout [Double] /*12*/,dblTotal: inout Double,fTime: Double){
        
    }
    
    internal static func NormalizeMeridians(dblMeridians: inout [Double] /*12*/){
        
    }
    
    static func MtGetReliabilityIndex(pStrokesArray: strokeNode)->Double{
        var fRet: Double = 0;
        let count=pStrokesArray.arrA.count
        if (count>=2){

            var fMinH: Double = 100.0;
            var fMaxH: Double = 0;

            for sz in 0..<count{
                let dblH = pStrokesArray.arrH[sz]

                if (dblH > fMaxH)
                {
                    fMaxH = dblH;
                }

                if (dblH < fMinH)
                {
                    fMinH = dblH;
                }
            }

            fRet = 120.0 - (fMaxH-fMinH);

            if (fRet > 100.0){
                fRet = 100.0
            }
        }

        return fRet
    }
    
    
};


func round_i1(_ x: Double) -> Int
{
    if (x-floor(x)>=0.5){
        return Int(ceil(x))
        
    }
    else {
        return Int(floor(x))
        
    }
}


func fft_double (_ p_nSamples: Int, _ p_bInverseTransform: Bool, _ p_lpRealIn: inout [Double], _ p_lpImagIn: inout [Double], _ p_lpRealOut: inout [Double], _ p_lpImagOut: inout [Double]){
    if (p_lpRealIn.count==0 || p_lpRealOut.count==0 || p_lpImagOut.count==0){
        return
    }

    var NumBits: Int
    var _: Int
    var j: Int
    var k: Int
    var _: Int
    var BlockSize: Int = 2
    var BlockEnd: Int

    var angle_numerator:Double = 2.0 * Double.pi;
    var tr: Double
    var ti: Double

    if (!IsPowerOfTwo(p_nSamples))
    {
        return;
    }

    if (p_bInverseTransform)
    {
        angle_numerator = -angle_numerator;
    }

    NumBits = NumberOfBitsNeeded(p_nSamples);


    for i in 0..<p_nSamples{
        j = Int(ReverseBits(i, NumBits))
        p_lpRealOut[j] = p_lpRealIn[i]
        p_lpImagOut[j] = (p_lpImagIn.count==0) ? 0.0 : p_lpImagIn[i]
    }

    BlockEnd = 1;
    while( BlockSize <= p_nSamples){
    //for (BlockSize=2; BlockSize<=p_nSamples; BlockSize<<=1){
        let delta_angle: Double = angle_numerator / Double(BlockSize)
        let sm2: Double = sin(-2 * delta_angle);
        let sm1: Double = sin(-delta_angle);
        let cm2: Double = cos(-2 * delta_angle);
        let cm1: Double = cos(-delta_angle);
        let w: Double = 2 * cm1;
        var ar=[Double].init(repeating: 0, count: 3)
        var ai=[Double].init(repeating: 0, count: 3)

        for i in stride(from: 0, to: p_nSamples, by: BlockSize){

            ar[2] = cm2;
            ar[1] = cm1;

            ai[2] = sm2;
            ai[1] = sm1;

            j=i
            for _ in 0..<BlockEnd{
            //for (j=i, n=0; n<BlockEnd; j++, n++){
                ar[0] = w*ar[1] - ar[2];
                ar[2] = ar[1];
                ar[1] = ar[0];

                ai[0] = w*ai[1] - ai[2];
                ai[2] = ai[1];
                ai[1] = ai[0];

                k = j + BlockEnd;
                tr = ar[0]*p_lpRealOut[k] - ai[0]*p_lpImagOut[k];
                ti = ar[0]*p_lpImagOut[k] + ai[0]*p_lpRealOut[k];

                p_lpRealOut[k] = p_lpRealOut[j] - tr;
                p_lpImagOut[k] = p_lpImagOut[j] - ti;

                p_lpRealOut[j] += tr;
                p_lpImagOut[j] += ti;
                j += 1
            }
        }

        BlockEnd = BlockSize;
        BlockSize *= 2
    }


    if (p_bInverseTransform)
    {
        let denom: Double = Double(p_nSamples)

        for i in 0..<p_nSamples{
            p_lpRealOut[i] /= denom;
            p_lpImagOut[i] /= denom;
        }
    }
}


func IsPowerOfTwo(_ p_nX: Int)->Bool{

    if (p_nX < 2){
        return false
    }
//MARK: проверить
    if (p_nX & (p_nX-1) > 0){
        return false
            }

    return true

}


func NumberOfBitsNeeded(_ p_nSamples: Int)->Int{

    var i: Int = 0

    if (p_nSamples < 2){
        return 0
    }

    while(true){
        if ((p_nSamples & (1 << i)) > 0){
            return i
        }
        i += 1
    }

}

func ReverseBits(_ p_nIndex: Int, _ p_nBits: Int)->Int{

    var rev: Int = 0
    var p_nIndex2=p_nIndex
    
    for _ in 0..<p_nBits{
        rev = (rev << 1) | (p_nIndex2 & 1)
        p_nIndex2 >>= 1
    }

    return rev

}
