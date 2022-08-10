package com.drawonapp.appleanimation


import android.animation.ValueAnimator
import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Canvas
import android.graphics.Paint
import android.graphics.RectF
import android.os.Build
import android.util.AttributeSet
import android.view.View
import android.widget.TextView
import androidx.annotation.RequiresApi

/***
 * value animator generates the values within the range (0,360)
 * Each time value is updated the invalidate() method is called in onUpdateListener() which essentially calls onDraw() method
 * inside onDraw() method canvas.drawArc() method is called
 * canvas.drawArc() draws an arc with percentage such as 0..1...10..to 360
 */

class ArcAnimation(
    context: Context?,
    attrs: AttributeSet?
) : View(context, attrs) {

    /*** Range of percentage from 0 to 360 **/
    private var perCent : Int = 0

    private var paint = Paint()


    @SuppressLint("DrawAllocation")
    override fun onDraw(canvas: Canvas?) {
        val dimensions = RectF((width/2-200).toFloat(),(height/2-200).toFloat(),
            (width/2+200).toFloat(),(height/2+200).toFloat())

        paint.apply {
            this.color = resources.getColor(R.color.background_color)
            this.style = Paint.Style.STROKE
            this.strokeCap = Paint.Cap.ROUND
            this.strokeWidth = 14F
        }

        canvas!!.drawArc(dimensions, 270f, 360f, false, paint)

        paint.apply {
            this.color = resources.getColor(R.color.blue)
            this.style = Paint.Style.STROKE
            this.strokeCap = Paint.Cap.ROUND
            this.strokeWidth = 14F
        }

        canvas.drawArc(dimensions, 270f, perCent.toFloat(), false, paint)
    }


    fun start_animation(textView: TextView) {
        val value_animator = ValueAnimator.ofInt(0,360)
        value_animator.duration = 3000
        value_animator.addUpdateListener {
            perCent = it.animatedValue as Int
            if (perCent == 360) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    textView.setTextColor(context.getColor(R.color.blue))
                }
                textView.text = "Sent"
            }
            invalidate()
        }

        value_animator.start()

    }
}