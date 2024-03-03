function updatesteamjson
    set -l steamid (cat ~/.local/steam/steamid)
    _updatesteamjson_getowned $steamid \
        | jq '.response | .games' \
        | _updatesteamjson_normalize true > ~/.local/steam/games.json

    begin
        cat ~/.local/steam/games.json
        _updatesteamjson_getapp \
            | jq '.response | .apps' \
            | _updatesteamjson_normalize false
    end | jq --slurp -c 'unique_by(.id) | .[]' > ~/.local/steam/allgames.json

end

function _updatesteamjson_getapp
    steamctl webapi call IStoreService.GetAppList max_results=49999
end

function _updatesteamjson_getowned -a steamid
    steamctl webapi call IPlayerService.GetOwnedGames steamid=$steamid include_appinfo=true include_played_free_games=true include_free_sub=true
end

function _updatesteamjson_normalize -a owned
    jq -c ".[] | { id: .appid, name, owned: $owned }"
end
