using FluentAssertions;
using NUnit.Framework;
using System.Linq;

namespace ReverseTest
{
    [TestFixture]
    public class NowaKlasa
    {
        [Test]
        public void ReveresedTextMatchesExpected()
        {
            const string text = "Ala ma kota";
            const string expected = "kota ma Ala";

            Reverse(text).Should().Be(expected, "Reversed text should match expected");
        }

        public static string Reverse(string text)
        {
            return string.Join(" ", text?.Split(' ').Reverse().ToArray());
        }
    }
}