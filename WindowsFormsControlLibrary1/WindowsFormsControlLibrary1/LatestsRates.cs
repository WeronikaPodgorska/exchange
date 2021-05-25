using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace WindowsFormsControlLibrary1
{
    [DataContract]
    public class LatestRates
    {
        [DataMember]
        public bool Success { get; set; }

        [DataMember]
        public int? Timestamp { get; set; }

        [DataMember]
        public string Base { get; set; }

        [DataMember]
        public DateTime Date { get; set; }

        [DataMember]
        public Dictionary<string, double> Rates { get; set; }
    }
}
