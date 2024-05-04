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

#サービス名から情報を取り出す
function show_password(){

    
    read -p "サービス名を入力してください: "  service_name


    #サービス名の有無の記録フラグ
    exists_flag=0


    while read record
    do

        #暗号化された各行を復号化して変数に代入
        decript_record_origin=$(echo "$record" | openssl enc -d -aes-256-cbc -base64 -k $ENCRIPT_PASSWORD -pbkdf2 -iter $ITER_COUNT)
        #復号化された行を　”：”　に基づいて配列に分割
        IFS=: read -r -a decript_record_arry <<< "$decript_record_origin"

        #0番目がサービス名
        if [ ${decript_record_arry[0]} = "$service_name" ] ; then
                
            echo サービス名:${decript_record_arry[0]}
            echo ユーザー名:${decript_record_arry[1]}
            echo パスワード:${decript_record_arry[2]}
            
                
            exists_flag=1
        fi

    done < password.txt

    if [ $exists_flag -eq 0 ] ; then
        echo "そのサービスは登録されていません。"
    fi

}




##################################################################################################




#エントリーポイント
function main(){

    echo "パスワードマネージャーへようこそ!"


    #空白で分割するよう設定　（念の為）
    IFS=' '
    
    while true
    do
        read -p "次の選択肢から入力してください。(Add Password/Get Password/Exit) :" -a arry_
        input_="${arry_[*]}"
        
        if [ "$input_" = "Exit" ]; then
            echo "Thank you!"
            exit
        elif [ "$input_" = "Add Password" ]; then
            regist_password
        elif [ "$input_" = "Get Password" ]; then
            show_password
        else
            echo "再入力してください。"

        fi

    done    
        
}



##################################################################################################



#実行ポイント
main


