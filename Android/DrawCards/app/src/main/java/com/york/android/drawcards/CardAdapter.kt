package com.york.android.drawcards

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.Drawable
import android.os.Build
import android.support.annotation.RequiresApi
import android.support.v4.content.ContextCompat
import android.support.v7.widget.RecyclerView
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.animation.AnimationUtils
import android.widget.ImageView

class CardAdapter(val cards: ArrayList<Card>, val context: Context) : RecyclerView.Adapter<CardAdapter.CardHolder>() {
    private val list: List<Card> = listOf(cards.last()) + cards + listOf<Card>(cards.first())

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CardHolder {
        val cardView = LayoutInflater.from(context).inflate(R.layout.carditem_recyclerview, parent, false)
        val holder = CardHolder(cardView)
        return holder
    }

    override fun getItemCount(): Int {
        return list.size * 100
    }

    fun getListSize() = list.size

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN)
    override fun onBindViewHolder(holder: CardHolder, position: Int) {
        holder.bind(list[position % list.size])
    }

    inner class CardHolder(itemView: View?) : RecyclerView.ViewHolder(itemView) {
        @RequiresApi(Build.VERSION_CODES.JELLY_BEAN)
        fun bind(card: Card) {
            itemView.findViewById<ImageView>(R.id.imageView_cardItem_card).apply {
                val cardBitmap = BitmapFactory.decodeResource(resources, card.drawableId)
                setImageBitmap(cardBitmap)
                Log.d("Adapter", "drawableId: ${card.drawableId}")
                background = ContextCompat.getDrawable(context, card.backgroundId)
            }
        }
    }
}