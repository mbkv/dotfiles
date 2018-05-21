function rpass -a length -d "Output some random base64 password"
    if test -z $length
        set length 24
    end

    echo (head -c $length /dev/urandom | base64 -w 0 | sed 's/[\/=+]//g')
end

