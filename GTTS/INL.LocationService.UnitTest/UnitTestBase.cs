using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace INL.LocationService.UnitTest
{
    public class UnitTestBase
    {
        public UnitTestBase()
        {
            AssertFailure = false;
        }

        public void AreEqual<T1, T2>(string name, T1 o1, T2 o2)
        {
            try
            {
                Assert.AreEqual(o1, o2);
            }
            catch (Exception)
            {
                TestContext.WriteLine(string.Format("FAIL: {0} values not equal: {{Expected: {1}; Actual: {2}}}", name, o1, o2));
                AssertFailure = true;
            }
        }
        public void IsTrue(string name, bool test)
        {
            try
            {
                Assert.IsTrue(test);
            }
            catch (Exception)
            {
                TestContext.WriteLine(string.Format("FAIL: {0} value returned false", name));
                AssertFailure = true;
            }
        }


        public TestContext TestContext { get; set; }
        public bool AssertFailure { get; set; }
    }
}