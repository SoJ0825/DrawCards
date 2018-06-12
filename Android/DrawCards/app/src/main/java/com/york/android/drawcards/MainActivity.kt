package com.york.android.drawcards

import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.support.v7.widget.LinearLayoutManager
import android.support.v7.widget.PagerSnapHelper
import android.support.v7.widget.RecyclerView
import android.util.Log
import android.view.View
import android.widget.LinearLayout
import kotlinx.android.synthetic.main.activity_main.*
import java.util.concurrent.Executors
import java.util.concurrent.Future

class MainActivity : AppCompatActivity() {
    val cards = ArrayList<Card>()
    var smokes = ArrayList<Card>()
    var innerSmokes = ArrayList<Int>()

    lateinit var onScrollListener: OnScrollListener
    lateinit var cardAdapter: CardAdapter
    lateinit var smokeAdapter: CardAdapter

    lateinit var longRunningTaskFuture: Future<*>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        initCards()
        initSmokes()
        initRecyclerView()
        autoAnimSmoke()

        button_open.setOnClickListener {
            // cardAdapter.itemCount - 1
//            recyclerView_main.smoothScrollToPosition(100)
            imageView_main_cardBack.visibility = View.GONE
            imageView_main_smoke.visibility = View.GONE
            autoShine()
            autoScroll()
        }
    }

    fun initCards() {
        for (i in 0..3) {
            when (i % 3) {
                0 -> {
                    val card = Card(R.drawable.role_1, R.drawable.card_slot_60x73_03)
                    cards.add(card)
                }
                1 -> {
                    val card = Card(R.drawable.role_2, R.drawable.card_slot_60x73_04)
                    cards.add(card)
                }
                2 -> {
                    val card = Card(R.drawable.role_3, R.drawable.card_slot_60x73_05)
                    cards.add(card)
                }

            }
        }
    }

    fun initRecyclerView() {
        cardAdapter = CardAdapter(cards, this)
        val layoutManager = LinearLayoutManager(this, LinearLayout.HORIZONTAL, false)
        recyclerView_main.layoutManager = layoutManager
        recyclerView_main.adapter = cardAdapter
//        val snapHelper = PagerSnapHelper()
//        snapHelper.attachToRecyclerView(recyclerView_main)

        cardAdapter.getListSize().takeIf { it > 1 }?.apply {
            onScrollListener = OnScrollListener(cardAdapter.getListSize(), layoutManager)
            recyclerView_main.addOnScrollListener(onScrollListener)
            recyclerView_main.scrollToPosition(cardAdapter.getListSize())
        }
    }

    fun autoShine() {
        view_main_shine.visibility = View.VISIBLE

        var i = 0f
        val handler = Handler()
        val runnable = object : Runnable {
            override fun run() {
                if (i < 1f) {
                    Log.d("autoShine", "i: ${i}")
                    i = i + 0.1f
                    view_main_shine.alpha = i
                    handler.postDelayed(this, 100)
                } else {
                    view_main_shine.visibility = View.GONE
                    autoScroll()
                }
            }
        }
        handler.postDelayed(runnable, 0)
    }

    fun autoScroll() {
        val handler = Handler()
        var time = 0f

        val runnable = object : Runnable {
            override fun run() {
                recyclerView_main.scrollBy(50, 0)
                time = time + 0.1f

                if (time <= 20f) {
                    Log.d("MainActivity", "time: ${time}")
                    handler.postDelayed(this, time.toLong())
                } else {
                    imageView_main_innerSmoke.visibility = View.VISIBLE
                }
            }
        }
        handler.postDelayed(runnable, 0)
    }

    fun initSmokes() {
        val loadSmoke = LoadSmoke()
        val loadInnerSmoke = LoadInnerSmoke()
        smokes = loadSmoke.loadSmokeBitmap()
        innerSmokes = loadInnerSmoke.loadSmokes()
    }

    fun autoAnimSmoke() {
        var i = 1
        val handler = Handler()
        val runnable = object : Runnable {
            override fun run() {
                if (i <= 29) {
                    imageView_main_smoke.setImageDrawable(getDrawable(smokes[i].drawableId))
                    imageView_main_innerSmoke.setImageDrawable(getDrawable(innerSmokes[i]))
                    i++
                } else {
                    i = 1
                }
                handler.postDelayed(this, 20)
            }
        }
        handler.postDelayed(runnable, 0)
    }

    inner class OnScrollListener(val itemCount: Int, val layoutManager: LinearLayoutManager) : RecyclerView.OnScrollListener() {
        override fun onScrolled(recyclerView: RecyclerView?, dx: Int, dy: Int) {
            super.onScrolled(recyclerView, dx, dy)
            val firstItemVisible = layoutManager.findFirstVisibleItemPosition()

            if (firstItemVisible > itemCount && firstItemVisible % itemCount == 0) {
                //
                recyclerView_main.scrollToPosition(itemCount)
            } else if (firstItemVisible == itemCount - 1) {
                recyclerView_main.scrollToPosition(itemCount * 2)
            }
        }
    }
}
