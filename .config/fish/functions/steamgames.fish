function steamgames
    set -l query
    set -l text
    set -l f ~/.local/steam/games.json

    getopts $argv | while read -l key value
        switch $key
            case _
                set -a text "$value"
            case '*'
                if test "$value" != "true"
                    set -a text "$value"
                end
        end
        switch $key
            case all a
                set f ~/.local/steam/allgames.json
            case owned o
                set -a query 'owned'
            case id i
                set -a query 'id:"\(.id)"'
            case steam s
                set -a query 'steam:"steam://nav/games/details/\(.id)"'
            case store t
                set -a query 'store:"steam://store/\(.id)"'
            case steamdb d
                set -a query 'db:"https://steamdb.info/app/\(.id)"'
            case proton p
                set -a query 'proton:"https://www.protondb.com/app/\(.id)"'
            case youtube y
                set -a query 'youtube:.name | url_encode | "https://www.youtube.com/results?search_query=\(.)"'
        end
    end

    set commas (string join "," $query)

    set url_replacement "\
def url_encode:
   # The helper function checks whether the input corresponds to one of the characters: !'()*
   def recode: . as \$c | [33,39,40,41,42] | index(\$c);
   def hex:   if . < 10 then 48 + . else  55 + . end;
   @uri
   | split(\"%20\")
   | join(\"+\")
   | explode
   # 37 ==> \"%\", 50 ==> \"2\"
   | map( if recode then (37, 50, ((. - 32) | hex)) else . end )
   | implode;"

   echo $commas

    cat $f | \
        _steamgames_find $text | \
        jq "$url_replacement map({ name, $commas })"
end

function _steamgames_find
    if test (count $argv) -eq 0
        cat -
    else
        jq -c ".[] | select(.name | test(\"$argv[1]\"; \"i\"))" \
            | _steamgames_find $argv[2..-1]
    end
end

