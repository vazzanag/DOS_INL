using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace INL.MessagingService.UnitTest
{
    public class UnitTestBase
    {
        public UnitTestBase()
        {
            AssertFailure = false;
        }

        /// <summary>
        /// Checks of two objects are equal
        /// </summary>
        /// <typeparam name="T1"></typeparam>
        /// <typeparam name="T2"></typeparam>
        /// <param name="name">Name of objects being evaluated</param>
        /// <param name="o1">Expected value</param>
        /// <param name="o2">Actual value</param>
        public void AreEqual<T1, T2>(string name, T1 o1, T2 o2)
        {
            try
            {
                if (o1.GetType() == typeof(DateTime))
                    Assert.AreEqual(Convert.ToDateTime(o1).Date, Convert.ToDateTime(o2).Date);
                else
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
