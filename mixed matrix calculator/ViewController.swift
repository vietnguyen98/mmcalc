//
//  ViewController.swift
//  mixed matrix calculator
//
//  Created by Viet Nguyen on 7/23/18.
//  Copyright © 2018 Viet Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ans: UILabel!
    @IBOutlet weak var currMatLabel: UILabel!
    @IBOutlet weak var size: UILabel!
    @IBOutlet weak var P1Strat: UILabel!
    @IBOutlet weak var P2Strat: UILabel!
    
    // 0=A, 1=B, 2=C
    var currMat = 0
    
    var currstrat = ["",""]
    var stratA = ["",""]
    var stratB = ["",""]
    var stratC = ["",""]
    
    var currsize = [0, 0]
    var sizeA = [0, 0]
    var sizeB = [0, 0]
    var sizeC = [0, 0]
    
    var currval = 0.0
    var valueA = 0.0
    var valueB = 0.0
    var valueC = 0.0
    
    var currmatrix = [0.0, 0, 0, 0]
    var matrixA = [0.0, 0, 0, 0]
    var matrixB = [0.0, 0, 0, 0]
    var matrixC = [0.0, 0, 0, 0]
    
    // 0=X, 1=number, 2=A, 3=B, 4=C
    var currbool = [0, 0, 0, 0]
    var boolA = [0, 0, 0, 0]
    var boolB = [0, 0, 0, 0]
    var boolC = [0, 0, 0, 0]
    
    // single position in boolean matrix with recursion
    var recursivepos = -1
    
    @IBOutlet var values: [UITextField]!
    
    
    @IBAction func calc(_ sender: Any? ) {
        for n in 0...3{
            if(values[n].text=="X"){
                currbool[n] = 0
                currmatrix[n] = 0
            }
            else if(values[n].text=="A"){
                currbool[n] = 2
                currmatrix[n] = valueA
            }
            else if(values[n].text=="B"){
                currbool[n] = 3
                currmatrix[n] = valueB
            }
            else if(values[n].text=="C"){
                currbool[n] = 4
                currmatrix[n] = valueC
            }
            else{
                 currbool[n] = 1
                currmatrix[n] = (values[n].text! as NSString).doubleValue
                }
        }
        print(currbool)
        print(currmatrix)
        if(currbool[0]==0){
            size.text = "size: 0x0"
            ans.text = "0.0"
            currsize = [0, 0]
            currval = 0
            currstrat=["",""]
        }
        else if(currbool[1]==0 && currbool[2]==0 && currbool[3]==0){
            size.text = "size: 1x1"
            ans.text = String(currmatrix[0])
            currsize = [1, 1]
            currval = currmatrix[0]
            currstrat=["(1)","(1)"]
        }
        else if(currbool[1]==0 && currbool[3]==0){
            size.text = "size: 2x1"
            currsize = [2, 1]
            currval = min(currmatrix[0],currmatrix[2])
            ans.text = String(currval)
            if(currmatrix[0]<=currmatrix[2]){
                currstrat=["(1,0)","(1)"]
            }
            else{
                currstrat=["(0,1)","(1)"]
            }
        }
        else if(currbool[2]==0 && currbool[3]==0){
            size.text = "size: 1x2"
            currsize = [1, 2]
            currval = min(currmatrix[0],currmatrix[1])
            ans.text = String(currval)
            if(currmatrix[0]<=currmatrix[1]){
                currstrat=["(1)","(1,0)"]
            }
            else{
                currstrat=["(1)","(0,1)"]
            }
        }
        else{
            size.text = "size: 2x2"
            currsize = [2, 2]
            // calculate value and mixed strategies
            let a = currmatrix[0]
            let b = currmatrix[1]
            let c = currmatrix[2]
            let d = currmatrix[3]
            // look for row dominance, column dominance,
            // then use general formula
            if(a>=c && b>=d){
                currval = min(a,b)
                if(a<=b){
                    currstrat=["(1,0)","(1,0)"]
                }
                else{
                    currstrat=["(1,0)","(0,1)"]
                }
            }
            else if(c>=a && d>=b){
                currval = min(c,d)
                if(c<=d){
                    currstrat=["(0,1)","(1,0)"]
                }
                else{
                    currstrat=["(0,1)","(0,1)"]
                }
            }
            else if(b>=a && d>=c){
                currval = max(a,c)
                if(a>=c){
                    currstrat=["(1,0)","(1,0)"]
                }
                else{
                    currstrat=["(0,1)","(1,0)"]
                }
            }
            else if(a>=b && c>=d){
                currval = max(b,d)
                if(b>=d){
                    currstrat=["(1,0)","(0,1)"]
                }
                else{
                    currstrat=["(0,1)","(0,1)"]
                }
            }
            else{
                var v = (a*d-b*c)/(a-b-c+d)
                let v2 = Int(v*100)
                v = Double(v2)/100
                var m = (d-c)/(a-b-c+d)
                let m2 = Int(m*10000)
                m = Double(m2)/10000
                var n = (d-b)/(a-b-c+d)
                let n2 = Int(n*10000)
                n = Double(n2)/10000
                let string1="("+String(m)+","+String(1-m)+")"
                let string2="("+String(n)+","+String(1-n)+")"
                currval=v
                currstrat=[string1,string2]
            }
            ans.text = String(currval)
        }
        P1Strat.text = "P1: "+currstrat[0]
        P2Strat.text = "P2: "+currstrat[1]
        if(currMat==0){
            sizeA=currsize
            valueA=currval
            matrixA=currmatrix
            boolA=currbool
            stratA=currstrat
        }
        else if(currMat==1){
            sizeB=currsize
            valueB=currval
            matrixB=currmatrix
            boolB=currbool
            stratB=currstrat
        }
        else{
            sizeC=currsize
            valueC=currval
            matrixC=currmatrix
            boolC=currbool
            stratC=currstrat
        }
    }
    
    
    @IBAction func setMatrix(_ sender: UIButton) {
        self.calc(nil)
        print("setmatrix:")
        if(sender.tag==1){
            currMat=0
            currMatLabel.text = "Matrix A"
            ans.text=String(valueA)
            size.text = "size: " + String(sizeA[0]) + "x" + String(sizeA[1])
            currmatrix = matrixA
            currbool = boolA
            currstrat = stratA
            print("A")
        }
        else if(sender.tag==2){
            currMat=1
            currMatLabel.text = "Matrix B"
            ans.text=String(valueB)
            size.text = "size: " + String(sizeB[0]) + "x" + String(sizeB[1])
            currmatrix = matrixB
            currbool = boolB
            currstrat = stratB
            print("B")
        }
        else{
            currMat=2
            currMatLabel.text = "Matrix C"
            ans.text=String(valueC)
            size.text = "size: " + String(sizeC[0]) + "x" + String(sizeC[1])
            currmatrix = matrixC
            currbool = boolC
            currstrat = stratC
            print("C")
        }
        P1Strat.text = "P1: "+currstrat[0]
        P2Strat.text = "P2: "+currstrat[1]
        print(currbool)
        print(currmatrix)
        print(matrixA)
        print(matrixB)
        print(matrixC)
        // 0=X, 1=number, 2=A, 3=B, 4=C
        for n in 0...3{
            if(currbool[n]==0){
                values[n].text="X"
            }
            else if(currbool[n]==1){
                values[n].text=String(currmatrix[n])
            }
            else if(currbool[n]==2){
                values[n].text="A"
            }
            else if(currbool[n]==3){
                values[n].text="B"
            }
            else{
                values[n].text="C"
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for n in 0...3{
            values[n].text="X"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

