package global
{
    import flash.geom.Point;
    import flash.utils.Timer;
    import flash.utils.describeType;

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

        public static function distanceBetweenTwoPoints(point1:Point, point2:Point):Number
        {
            return Math.sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y));
        }

        public static function degreesBetweenTwoPoints(p1:Point, p2:Point):Number
        {
            return toDegrees(Math.atan2(p2.y - p1.y, p2.x - p1.x));
        }

        public static function differenceBetweenTwoDegrees(d1:Number, d2:Number):Number
        {
            return toDegrees(Math.atan2(Math.sin(d1 - d2), Math.cos(d1 - d2)));
        }

        public static function round(value:Number):Number
        {
            return Math.round(1024 * value) / 1024;
        }

        public static function toDegrees(value:Number):Number
        {
            return round(value * 180 / Math.PI);
        }

        public static function toRadians(value:Number):Number
        {
            return value * Math.PI / 180
        }

        public static function pointFromAngleAndDistance(point:Point, degrees:Number, distance:Number):Point
        {
            var r:Number = toRadians(degrees);
            return new Point(point.x + Math.cos(r) * distance, point.y + Math.sin(r) * distance);
        }

        public static function iconFromDirection(value:Number):Class
        {
            var iconsByDirection:Object = {
                0: Icons.CircledUp,
                45: Icons.CircledRightUp,
                90: Icons.CircledRight,
                135: Icons.CircledRightDown,
                180: Icons.CircledDown,
                225: Icons.CircledLeftDown,
                270: Icons.CircledLeft,
                315: Icons.CircledLeftUp
            };
            return iconsByDirection[value];
        }

        public static function labelFromDirection(value:Number):String
        {
            var labelsFromDirection:Object = {
                0: Local.text('north'),
                45: Local.text('north-east'),
                90: Local.text('east'),
                135: Local.text('south-east'),
                180: Local.text('south'),
                225: Local.text('south-west'),
                270: Local.text('west'),
                315: Local.text('north-west')
            };
            return labelsFromDirection[value];
        }
    }
}