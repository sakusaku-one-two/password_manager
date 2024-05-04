#!/bin/bash

#-------------------------------------#

    #Ubuntu 22.04.4 LTS にて作成しました。

#-------------------------------------#


#password.txtの暗号化の為のパスワード
ENCRIPT_PASSWORD=2a29d438111b7c96bd33c3c99ee3ee43

#暗号化と復号化の畳み込み？の回数
ITER_COUNT=10000



##################################################################################################




#サービス名・ユーザー名・パスワードを暗号化してpassword.txtに保存する
function regist_password(){

    #登録内容を入力
    read -p "サービス名を入力してください!" service_name
    read -p "ユーザー名を入力してください!" user_name
    read -p "パスワードを入力してください!" password


    #登録内容を一行の文字列にして変数に代入
    save_strings=${service_name}:${user_name}:${password}


    #暗号化して最終行に追加
    encript_strings=$(echo "$save_strings" | openssl enc -e -aes-256-cbc -base64  -k $ENCRIPT_PASSWORD -pbkdf2 -iter $ITER_COUNT)
    echo  "$encript_strings" >> password.txt


    echo "パスワードの追加は成功しました。"
    
}




##################################################################################################

