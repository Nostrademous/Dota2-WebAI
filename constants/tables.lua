-------------------------------------------------------------------------------
--- AUTHORS: Nostrademous
--- GITHUB REPO: https://github.com/Nostrademous/Dota2-WebAI
-------------------------------------------------------------------------------

tableBotActions = {
    BOT_ACTION_TYPE_NONE            = 0,
    BOT_ACTION_TYPE_IDLE            = 1,
    BOT_ACTION_TYPE_MOVE_TO         = 2,
    BOT_ACTION_TYPE_ATTACK          = 3,
    BOT_ACTION_TYPE_ATTACKMOVE      = 4,
    BOT_ACTION_TYPE_USE_ABILITY     = 5,
    BOT_ACTION_TYPE_PICK_UP_RUNE    = 6,
    BOT_ACTION_TYPE_PICK_UP_ITEM    = 7,
    BOT_ACTION_TYPE_DROP_ITEM       = 8
}

tableItemPurchaseResults = {
	PURCHASE_ITEM_SUCCESS				    = -1,
    PURCHASE_ITEM_UNIT_NOT_PLAYER_CONTROLED = 0,
	PURCHASE_ITEM_OUT_OF_STOCK			    = 82,
	PURCHASE_ITEM_DISALLOWED_ITEM		    = 78,
	PURCHASE_ITEM_INSUFFICIENT_GOLD		    = 63,
	PURCHASE_ITEM_NOT_AT_HOME_SHOP		    = 67,
	PURCHASE_ITEM_NOT_AT_SIDE_SHOP		    = 66,
	PURCHASE_ITEM_NOT_AT_SECRET_SHOP	    = 62,
	PURCHASE_ITEM_INVALID_ITEM_NAME		    = 33
}