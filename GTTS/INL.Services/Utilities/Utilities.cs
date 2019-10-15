using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace INL.Services.Utilities
{
    public static class Utilities
    {
        public static string MultipleSpaceToSingle(string word)
        {
            if (String.IsNullOrWhiteSpace(word))
            {
                return String.Empty;
            }
            RegexOptions options = RegexOptions.None;
            Regex regex = new Regex(@"[ ]{2,}", options);
            return regex.Replace(word.Trim(), @" ");
        }

        public static string ToSentenceCase(string sentence)
        {
            if (String.IsNullOrWhiteSpace(sentence))
            {
                return String.Empty;
            }
            var lowerCase = sentence.ToLower();
            // matches the first sentence of a string, as well as subsequent sentences
            var r = new Regex(@"(^[a-z])|\.\s+(.)", RegexOptions.ExplicitCapture);
            // MatchEvaluator delegate defines replacement of setence starts to uppercase
            var result = r.Replace(lowerCase, s => s.Value.ToUpper());
            return result;
        }

        /// <summary>
        /// Converts all Diacritic characters in a string to their ASCII equivalent
        /// Courtesy: http://stackoverflow.com/a/13154805/476786
        /// A quick explanation:
        /// * Normalizing to form D splits charactes like è to an e and a nonspacing `
        /// * From this, the nospacing characters are removed
        /// * The result is normalized back to form C (I'm not sure if this is neccesary)
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string ConvertDiacriticToASCII(string value)
        {
            if (value == null) return null;
            var chars =
                value.Normalize(NormalizationForm.FormD)
                     .ToCharArray()
                     .Select(c => new { c, uc = CharUnicodeInfo.GetUnicodeCategory(c) })
                     .Where(@t => @t.uc != UnicodeCategory.NonSpacingMark)
                     .Select(@t => @t.c);
            var cleanStr = new string(chars.ToArray()).Normalize(NormalizationForm.FormC);
            return cleanStr;
        }
    }
}
