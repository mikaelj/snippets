//
// jwzrd's spellchecker, i.e. not written by mikael jansson
//

package se.jwzrd.spellchecking

import io.Source
import collection.immutable.{HashMap, SortedMap}

trait Index extends (String => Int) {
  def intersectionWith(words: Traversable[String]) =
    Set() ++ words filter ( w => this (w) > 0 )
}

object Indexer {
  def apply(sourceFile: String) =
    new Indexer {} apply (Source fromFile sourceFile)
}

trait Indexer extends (Iterator[Char] => Index) {
  def isLetter(c: Char) = Character isLetter c

  def words(s: Stream[Char]): Stream[String] = {
    val (w, rest) = s span isLetter

    (w mkString) #:: {
      if (!rest.isEmpty) words (rest dropWhile (c => !isLetter(c)))
      else Stream.Empty
    }
  }

  def apply(source: Iterator[Char]) = new Index {
    val table = {
      val initial = Map[String, Int]() withDefaultValue 0

//      words (source toStream).foldLeft(acc) { (b, a) => b + (a -> (b(a) + 1)) }
      words (source toStream).foldLeft (initial) { (b, a) => b(a) += 1 }
    }

    def apply(word: String) = table (word)
  }
}

trait Mutations extends (String => Set[String]) {
  def apply(word: String) = {
    val splits = for {
      i <- 0 to (word length)
    } yield word splitAt i

    val deletes = for {
      (a, b) <- splits if !(b isEmpty)
    } yield a + (b tail)

    val transposes = for {
      (a, b) <- splits if (b length) > 1
    } yield a + b(1) + b(0) + (b drop 2)

    val replaces = for {
      (a, b) <- splits if !(b isEmpty)
      c <- 'a' to 'z'
    } yield a + c + (b tail)

    val inserts = for {
      (a, b) <- splits
      c <- 'a' to 'z'
    } yield a + c + b

    Set() ++ deletes ++ transposes ++ replaces ++ inserts
  }
}

case class Corrector(index: Index, mutations: Mutations) extends (String => String) {
  def candidates(word: String) = {
    val mutations0 = mutations (word)
    val mutations1 = for {
      m0 <- mutations0
      m1 <- mutations (m0) if index (m1) > 0
    } yield m1

    def known(words: Traversable[String]) = index intersectionWith words

    known (Set (word)) | known (mutations0) | mutations1
  }

  def apply(word: String): String = candidates (word) match {
    case xs if !xs.isEmpty => xs reduceLeft { (b, a) =>
      if (index (b) > index (a)) b
      else a
    }
    case _ => word
  }
}

object Comparison {
  def test(word: String)(implicit correct: Corrector) =
    println(word + " -> " + correct (word))

  def main(args: Array[String]) {

    val start = System currentTimeMillis

    val index = Indexer (args(0))
    val mutations = new Mutations {}
    implicit val correct = Corrector (index, mutations)

    // This is fucked. corect -> direct? What happened to correct? The weights
    // of the dictionary mean too much. I have to weigh the distance against
    // the frequency
    test("corect")

/*
    val words = List("klaus", "jenny", "patrik", "kapybara", "transvstajt",
                     "transvestiit", "homersexual", "mavvelus", "ap-roach",
                     "kvicker", "kuicker", "badibilder", "bodibilder",
                     "efforlesnes", "effortlessness", "efot", "dissipliin",
                     "dissipliin", "discipliin", "dissipline", "grejpfruit",
                     "encompascing", "virtoes")

    words foreach (test)
*/

    val end = System currentTimeMillis

    println("Time: " + (end - start))
  }
}

object Runner {
  def main(args: Array[String]) {
    print("Indexing...")
    val indexStart = System currentTimeMillis
    val index = Indexer (args(0))
    val indexEnd = System currentTimeMillis

    println("Done (" + (indexEnd - indexStart) + ")")

    val mutations = new Mutations {}

    val testWord = "patrik"

/*
    print("Mutating...")
    val mutationStart = System currentTimeMillis

    val s = mutations splits testWord

    val d = mutations deletes testWord

    val t = mutations transposes testWord

    val r = mutations replaces testWord

    val i = mutations inserts testWord

    val m = mutations (testWord)

    val mutationEnd = System currentTimeMillis

    println("Done (" + (mutationEnd - mutationStart) + ")")

    println("s = " + s)
    println("d = " + d)
    println("t = " + t)
    println("r = " + r)
    println("i = " + i)
    println("m = " + m)

*/
    val r0 = index("public")
    println("r0 = " + r0)

    val r1 = index("pubic")
    println("r1 = " + r1)

    val correct = Corrector (index, mutations)
    val c = correct candidates "puggic"
    println("c = " + c)

    val correction = correct ("puggic")
    println("suggestion = " + correction)

    val c0 = correct ("speling")
    println("c0 = " + c0)

    val c1 = correct ("korrecter")
    println("c1 = " + c1)

    val c2 = index ("spelling")
    println("c2 = " + c2)

    val c3 = index ("feeling")
    println("c3 = " + c3)

    val c4 = for {
      w <- correct candidates "speling"
    } yield (w, index (w))

    println("c4 = " + c4)

    val spelingMutations = mutations ("speling")
    println("spelingMutations = " + spelingMutations)

    val spelingIndexIntersection = index intersectionWith spelingMutations
    println("spelingIndexIntersection = " + spelingIndexIntersection)


  }
}
