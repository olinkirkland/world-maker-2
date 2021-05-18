package global
{
    import flash.desktop.NativeApplication;
    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.filesystem.File;
    import flash.system.Capabilities;
    import flash.utils.Timer;
    import flash.utils.describeType;

    import mx.utils.StringUtil;

    public class Util
    {
        public static var lorem:String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris maximus posuere lorem. Aliquam condimentum hendrerit interdum. Cras varius fringilla nisl, a placerat enim consequat nec. Cras porttitor aliquet mi.";

        [Embed(source='/assets/seeds.json', mimeType='application/octet-stream')]
        private static var SeedsJSON:Class;
        private static var seeds:Array;

        private static var months:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        private static var _timer:Timer;

        public static function get timer():Timer
        {
            if (!_timer)
            {
                _timer = new Timer(1000);
                _timer.start();
            }

            return _timer;
        }

        public static function randomSeed():String
        {
            if (!seeds)
                seeds = JSON.parse(new SeedsJSON()) as Array;

            return seeds[int(Math.random() * seeds.length - 1)];
        }

        public static function stringToSeed(str:String):Number
        {
            if (!str)
                return 0;

            var hash:Number = 0;
            for (var i:int = 0; i < str.length; i++)
            {
                hash = ((hash << 5) - hash) + str.charCodeAt(i);
                hash = hash & hash;
            }

            return Math.abs(hash);
        }

        public static function camelCaseToUnderScore(str:String):String
        {
            var regex:RegExp = new RegExp(/([A-Z])/g);
            return str.replace(regex, '_$1').toLowerCase();
        }

        public static function secondsSince(d:Date):Number
        {
            return Number(((new Date().time - d.time) / 1000).toFixed(4));
        }

        public static function minutesSince(d:Date):Number
        {
            return secondsSince(d) / 60;
        }

        public static function hoursSince(d:Date):Number
        {
            return minutesSince(d) / 60;
        }

        public static function daysSince(d:Date):Number
        {
            return hoursSince(d) / 24;
        }

        public static function log(v:*):void
        {
            trace(v);
        }

        public static function toRelativeDate(n:Number):String
        {
            var d:Date = new Date();
            d.time = n;

            var days:int = daysSince(d);
            var hours:int = hoursSince(d);
            var minutes:int = minutesSince(d);

            if (days < 5)
            {
                if (hours < 24)
                {
                    if (minutes < 60)
                    {
                        if (minutes < 5)
                        {
                            // Just now
                            return "just now";
                        } else
                        {
                            // Minutes ago
                            return minutes + " minutes ago";
                        }
                    } else
                    {
                        // Hours ago
                        return hours + " hours ago";
                    }
                } else
                {
                    // Days ago
                    return days + " days ago";
                }
            }

            // Don't use relative time
            if (days < 360)
                return months[d.month] + " " + d.date;

            // Include the year if it's that long ago
            return months[d.month] + " " + d.date + ", " + d.fullYear;
        }

        public static function toArray(iterable:*):Array
        {
            var arr:Array = [];
            for each (var elem:* in iterable)
                arr.push(elem);
            return arr;
        }

        public static function fixed(n:Number, places:int = 2):Number
        {
            return Number(n.toFixed(places));
        }

        public static function capitalizeFirstLetter(str:String):String
        {
            if (str.length == 0)
                return str;

            if (str.length == 1)
                return str.charAt(0).toUpperCase();
            else
                return str.charAt(0).toUpperCase() + str.substr(1);
        }

        public static function colorBetweenColors(color1:uint = 0xFFFFFF, color2:uint = 0x000000, percent:Number = 0.5):uint
        {
            if (percent < 0)
                percent = 0;
            if (percent > 1)
                percent = 1;

            var r:uint = color1 >> 16;
            var g:uint = color1 >> 8 & 0xFF;
            var b:uint = color1 & 0xFF;

            r += ((color2 >> 16) - r) * percent;
            g += ((color2 >> 8 & 0xFF) - g) * percent;
            b += ((color2 & 0xFF) - b) * percent;

            return (r << 16 | g << 8 | b);
        }

        public static function roundToNearest(n:Number, m:Number):Number
        {
            return int(n / m) * m;
        }

        public static function addZeroToSingleDigitString(str:String):String
        {
            while (str.length < 2)
                str = "0" + str;
            return str;
        }

        public static function readableByteCount(n:Number):String
        {
            for each (var str:String in ["B", "KB", "MB"])
            {
                if (n < 1000)
                    return n + " " + str;
                n = fixed(n / 1000, 1);
            }

            return n + " GB";
        }

        public static function toColorHex(color:uint):String
        {
            return "#" + color.toString(16);
        }

        public static function functionName(callee:Function, parent:Object):String
        {
            for each (var m:XML in describeType(parent)..method)
            {
                if (parent[m.@name] == callee) return m.@name;
            }

            return null;
        }

        public static function checkClassName(className:String, qualifiedClassName:String):Boolean
        {
            return className == qualifiedClassName.substr(qualifiedClassName.indexOf("::") + "::".length);
        }
    }
}