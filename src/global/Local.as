package global
{
    public class Local
    {
        [Embed(source='/assets/languages/en.json', mimeType='application/octet-stream')]
        private static var en:Class;

        [Embed(source='/assets/languages/pg.json', mimeType='application/octet-stream')]
        private static var pg:Class;

        private static var dictionary:Object;

        private static var _language:String;

        public static function text(key:String, args:Array = null):String
        {
            // Returns cell of key from the dictionary pair
            // If no such key exists, returns the key with brackets around it
            // If there are arguments, replace each "%%" in the key with an arg

            if (!dictionary)
                throw new Error("dictionary must be set first");

            if (!dictionary[key])
            {
                trace("@Local, missing key: " + key);
                if (args && args.length > 0)
                    return "[ " + key + " ] " + args.join(", ");
                return "[ " + key + " ]";
            }

            var str:String = dictionary[key];

            if (args)
                for each (var t:* in args)
                    str = str.replace("%%", t);

            return str;
        }

        public static function set language(id:String):void
        {
            _language = id;
            var languages:Object = {"en": en, "pg": pg};
            if (!languages[_language])
                return;

            var str:String = new languages[_language]();
            dictionary = JSON.parse(str);
        }

        public static function get language():String
        {
            return _language;
        }
    }
}
