using FluentAssertions;
using FluentAssertions.Execution;
using RestSharp;
using RestSharp.Serialization.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using TechTalk.SpecFlow;

namespace WindowsFormsControlLibrary1
{
    [Binding]
    public class LatestRatesSteps
    {
        private RestClient Client { get; set; }
        private IRestResponse Response { get; set; }
        private const string BaseAddress = "http://api.exchangeratesapi.io";
        private const string LatestEndpoint = "/v1/latest";

        [Given(@"I'm an ExhangeRates client")]
        public void GivenIMAnExhangeRatesClient()
        {
            Client = new RestClient(BaseAddress);
        }
        
        [When(@"I make a GET request to LatestRates with the following data: api key = (.*) and base = (.*) and symbols =(.*)")]
        public void WhenIMakeAGETRequestToLatestRatesWithTheFollowingParameters(string apiKey, string baseRate, string symbols)
        {
            var additionalParametersString = "&base=" + baseRate + "&symbols=" + symbols;
            var resource = LatestEndpoint+"?access_key="+apiKey+additionalParametersString;

            var request = new RestRequest(resource);
            Response = Client.Get(request);
        }
        
        [Then(@"the response status code is (.*)")]
        public void ThenTheResponseStatusCodeIs(int expectedStatusCode)
        {
            Response.StatusCode.Should().Be(expectedStatusCode, "Response code should match expected");
        }
        
        [Then(@"the response should contain following data: success = (.*) and base rate = (.*) and other rates = (.*) and rates values count = (.*) and date = current date")]
        public void ThenTheResponseShouldContain(bool success, string baseRate, string otherRates, int ratesValuesCount)
        {
            var expectedDate = DateTime.Now.Date;
            JsonDeserializer jd = new JsonDeserializer();
            var latestRatesResponse = jd.Deserialize<LatestRates>(Response);

            using (new AssertionScope())
            {
                List<string> ratesList = new List<string>(otherRates.Split(','));
                latestRatesResponse.Success.Should().Be(success);
                latestRatesResponse.Base.Should().Be(baseRate);
                latestRatesResponse.Date.Date.Should().Be(expectedDate);
                latestRatesResponse.Rates.Select(a => a.Key).ToList().Should().BeEquivalentTo(ratesList, "Rates names list should match expected");
                latestRatesResponse.Rates.Select(a => a.Value).ToList().Count().Should().Be(ratesValuesCount, "Number of Rates values should match expected");
                latestRatesResponse.Rates.Where(a => a.Key == baseRate).Select(b => b.Value).Should().BeEquivalentTo(1); //"Exchange rate for currency which is also base rate should always be 1"
                latestRatesResponse.Timestamp.Should().NotBeNull();
            }
        }

        [Then(@"the response error code is (.*)")]
        public void ResponseErrorCodeShouldBe(string errorCode)
        {
            Response.Content.Contains(errorCode).Should().BeTrue("Response should contain expected error code");
        }
    }
}
