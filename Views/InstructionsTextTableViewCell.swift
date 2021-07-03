//
//  InstructionsTextTableViewCell.swift
//  Air Conditioner
//
//  Created by loai elayan on 9/26/19.
//  Copyright © 2019 Converged Technology. All rights reserved.
//

import UIKit
import LanguageManager_iOS

class InstructionsTextTableViewCell: UITableViewCell
{
    
    @IBOutlet weak var addDeviceLabel: UILabel!
    @IBOutlet weak var remoteWithHealthLabel: UILabel!
    @IBOutlet weak var firstTextView: UITextView!
    @IBOutlet weak var remoteWithoutHealthLabel: UILabel!
    @IBOutlet weak var secondTextlabel: UITextView!
    @IBOutlet weak var firstNoteLabel: UILabel!
    @IBOutlet weak var thirdTextView: UITextView!

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        if LanguageManager.shared.currentLanguage == .en
        {
            addDeviceLabel.text = "ADD DEVICE"
            remoteWithHealthLabel.text = "Remote with Health Button"
            firstTextView.text = "Please make sure to turn on the AC, then press Health button on the remote controller 8 times to reset. A Beep Beep sound means reset successfully."
            remoteWithoutHealthLabel.text = "Remote without Health Button"
            secondTextlabel.text = "Please make sure to turn on the AC, then press Cool and + at same time for 3 seconds, the air conditioner rings 8 times and have a Beep Beep sound after 2 seconds means reset."
            firstNoteLabel.text = "If add device fails, check the following items"
            
            addDeviceLabel.textAlignment = .left
            remoteWithHealthLabel.textAlignment = .left
            firstTextView.textAlignment = .left
            remoteWithoutHealthLabel.textAlignment = .left
            secondTextlabel.textAlignment = .left
            firstNoteLabel.textAlignment = .left
        }else{
            addDeviceLabel.text = "اضافة جهاز أخر"
            remoteWithHealthLabel.text = "التحكم باستخدام الريموت مع زر Health"
            firstTextView.text = " يرجى التحقق أنه تم إعادة تعيين الجهاز بنجاح: اظغط زر HEALTH  (المتوفر في وحدة التحكم - الريموت كونترول) 8 مرات وذلك بتوجيه الريموت كونترول على الجهاز  لأعادة الضبط، بعد سماع صوت الصفارة هذا يعني انه تم  اعادة التعيين بنجاح."
            remoteWithoutHealthLabel.text = "التحكم باستخدام الريموت بدون زر Health"
            secondTextlabel.text = " إضغط على زر COLD و + في نفس الوقت لمدة 3 ثوانٍ على الريموت كونترول، إذا سمعت صوت الصفارة 8 مرات من الجهاز بعد ثانيتين فهذا يعني أنه تم إعادة ضبط الجهاز بنجاح."
            firstNoteLabel.text = "إذا فشلت عملية الإضافة الرجاء التحقق من التالي"
            
            addDeviceLabel.textAlignment = .right
            remoteWithHealthLabel.textAlignment = .right
            firstTextView.textAlignment = .right
            remoteWithoutHealthLabel.textAlignment = .right
            secondTextlabel.textAlignment = .right
            firstNoteLabel.textAlignment = .right
        }

        
        if LanguageManager.shared.currentLanguage == .en
        {
            thirdTextView.textAlignment = .left
            thirdTextView.text = "1. Check the WiFi icon on the air conditioner panel. If no WiFi icon is shown on the air conditioner, please contact customer service. Your air conditioner may not support WiFi.\n\n2. Make sure your mobile phone and your air conditioner are connected to the same WiFi. You should turn off the 3G/4G from your mobile device settings.\n\n3. Confirn the \"reset\" process is successful. Try to reset the air conditioner again by following the below steps.\n\n3.1 Press the HEALTH button on the remote control 8 times to reset, A \"drip drip\" sound means that the reset is successful.\n \n3.2 Press “Cool” and “+” at the same time for 3 seconds, the air conditioner rings 8 times and have a “Beep Beep” sound after 2 seconds, means reset is successful.\n\n4. Check the WiFi name from the router. The recommended name should not contain spaces and other non-alphanumeric characters. You can change the WiFi name from to your wireless router.\n\n5. Check the WiFi password matches the wireless router's configuration. The password shoould not be more than 30 bits. Recommended password should be letters and numbers. The password should not contain spaces or special symbols.\n\n6. Verify the WiFi password is entered correctly. You can confirm the password by selecting \"Show\" to see the enetered password."
            
        }else{
            thirdTextView.textAlignment = .right
            thirdTextView.text = "1. يرجى التحقق من أيقونة الشبكة على لوحة مكيف الهواء، إذا لم يتم عرض الرمز، فيرجى الاتصال بخدمة العملاء.\n\n2. يرجى التأكد من شبكة الهاتف المحمول WiFi 3G/4G للهاتف المحمول، لتكون متصلاً في WiFi\n\n3. يرجى التحقق أنه تم إعادة تعيين الجهاز بنجاح:\n اضغط زر HEALTH (المتوفر في وحدة التحكم - الريموت كونترول) 8 مرات وذلك بتوجيه الريموت كونترول على الجهاز لأعادة الضبط، بعد سماع صوت الصفارة هذا يعني انه تم اعادة التعيين بنجاح.\n\n3.2 إضغط على زر COLD و + في نفس الوقت لمدة 3 ثوانٍ على الريموت كونترول، إذا سمعت صوت الصفارة 8 مرات من الجهاز بعد ثانيتين فهذا يعني أنه تم إعادة ضبط الجهاز بنجاح.\n\n4. يرجى التحقق من اسم الشبكة (WiFi). إسم الشبكه يجب ألا يحتوي على فراغات أو إشارات خاصه (يجب أن يكون إسم الشبكه أحرف وأرقام فقط)\n\n5. يرجى التحقق من كلمة مرور الشبكة (WiFi).\n\n6. يرجى التحقق من صحة إدخال كلمة مرور الشبكة WiFi: يمكنك التحقق من كلمة المرور: إضغط على إظهار كلمة المرور لرو\'ية كلمة المرور التي قمت بادخالها\n\nالرجاء التأكد:\n1. اسم الشبكة وكلمة المرور صحيحة.\n2. إذا كانت الشبكة مخفية، فالرجاء تعديل الموجه وإلغاء الإخفاء.\n3. يرجى إيقاف وضع القائمة البيضاء لجهاز التوجيه.\n4. يرجى التحقق من إعادة تعيين المكيف بنجاح.\nحاول مجددا\nالرجاء الانتظار, تهيئة الجهاز يستغرق حوال دقيقة ..."
            
        }
        

    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
