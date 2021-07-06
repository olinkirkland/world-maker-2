package global
{
    public class Local
    {
        [Embed(source='/assets/languages/en.json', mimeType='application/octet-stream')]
        private static var en:Class;

        [Embed(source='/assets/languages/pig.json', mimeType='application/octet-stream')]
        private static var pig:Class;

        private static var dictionary:Object;

        public static function text(key:String, args:Array = null):String
        {
            // Returns cell of key from the dictionary pair
            // If no such key exists, returns the key with brackets around it
            // If there are arguments, replace each "%%" in the key with an arg

            if (!dictionary)
                language = "en";

            if (!dictionary[key])
            {
                //trace("@Local, missing key: " + key);
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

        private static function set language(id:String):void
        {
            var languages:Object = {"en": en, "pig": pig};
            if (!languages[id])
                return;

            var str:String = new languages[id]();
            dictionary = JSON.parse(str);
        }
    }
}
